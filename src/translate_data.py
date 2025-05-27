import re
import subprocess
import time

import geopandas as gpd
import requests

# input_file = "../data/POI_point/POI_point.gpkg"
input_file = "../data/Land_Use_Types/Land_Use_Types.gpkg"
output_file = input_file.replace(".gpkg", "_translated.gpkg")
target_language = "en"
skip_columns = [
    ".*id",
    ".*nr",
    ".*zahl",
    "url",
    "copyright",
    "geometry",
    "aend",
    "foto",
    "foto_small",
]


data = gpd.read_file(input_file)

process = subprocess.Popen(["libretranslate", "--port", "5000", "--load-only", "de,en"])


# Wait for server to be ready
def wait_for_server(timeout=10):
    for _ in range(timeout):
        try:
            requests.get("http://localhost:5000/health")
            return True
        except requests.ConnectionError:
            time.sleep(1)
    return False


if not wait_for_server():
    print("LibreTranslate server did not start in time.")
    process.terminate()
    exit(1)


# Translation function
def translate_text(text: str, source_lang: str = "de", target_lang: str = "en") -> str:
    url = "http://localhost:5000/translate"
    payload = {
        "q": text,
        "source": source_lang,
        "target": target_lang,
        "format": "text",
    }
    response = requests.post(url, json=payload)
    return response.json()["translatedText"]


def translate_list(
    text_list: list[str], source_lang: str = "de", target_lang: str = "en"
) -> list:
    text = "\n".join(text_list)
    translated_text = translate_text(text, source_lang, target_lang)
    return translated_text.split("\n")


translated_data = data.copy()

# Translate the columns
input_columns = list(data.columns)
translated_columns = translate_list(input_columns, target_lang=target_language)
columns_mapping = dict(zip(input_columns, translated_columns))
translated_data.rename(columns=columns_mapping, inplace=True)

# Filter out columns to skip with regex
input_columns_to_process = [
    col
    for col in input_columns
    if not any(re.search(pattern, col) for pattern in skip_columns)
]
translated_columns_to_process = [
    translated_col
    for col, translated_col in columns_mapping.items()
    if col in input_columns_to_process
]

# Translate the data
for column in translated_columns_to_process:
    if translated_data[column].dtype != "object":
        print(f"Skipping column {column} with dtype {translated_data[column].dtype}")
        continue
    print(
        f"Translating column {column} with {translated_data[column].nunique()} unique values"
    )
    print(f"Original values: {translated_data[column].unique()}")
    all_values = list(map(str, translated_data[column].unique()))
    all_values_translated = translate_list(
        all_values, source_lang="de", target_lang=target_language
    )
    # Create a mapping from original to translated values
    new_values = [
        f"{translated_value} ({original_value})"
        for translated_value, original_value in zip(all_values_translated, all_values)
    ]
    values_mapping = dict(zip(all_values, new_values))
    # Replace original values with translated values
    translated_data[column] = translated_data[column].map(values_mapping)

print(translated_data.head())

# Save the translated data to a new file
translated_data.to_file(output_file, driver="GPKG", overwrite=True)

# Clean up: terminate the server process
process.terminate()
process.wait()
