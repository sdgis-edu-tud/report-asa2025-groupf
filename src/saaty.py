import numpy as np
from tabulate import tabulate


def round_preserve_sum(values, digits):
    # Scale factor for digits of precision
    scale = 10**digits

    # Step 1: Scale values and compute initial rounded values
    scaled = np.array(values) * scale
    floored = np.floor(scaled)

    # Total units we still need to add to match sum
    missing_units = int(round(scale - np.sum(floored)))

    # Step 2: Sort indices by largest remainder / relative error
    # We prioritize the numbers where adding 1 introduces least relative error
    indices = sorted(
        range(len(values)), key=lambda i: (floored[i] + 1 - scaled[i]) / scaled[i]
    )

    # Step 3: Distribute the missing units to minimize percent error
    result = floored.copy()
    for i in indices[:missing_units]:
        result[i] += 1

    # Step 4: Convert back to floats with desired precision
    final = result / scale
    return final.tolist()


def calculate_weights(matrix: np.ndarray, method: str = "eigenvector"):
    """
    Calculate the weights of attributes using Saaty's method.

    Args:
        matrix (np.ndarray): The Saaty matrix representing pairwise comparisons.
        method (str): The method to use for calculating weights, either 'average' or 'eigenvector'.
    Returns:
        np.ndarray: The calculated weights of the attributes.
    """
    actual_matrix = np.array(
        list(map(lambda w: 1 / (-w) if w < 0 else w, matrix.flatten()))
    ).reshape(matrix.shape)

    if method == "average":
        # Normalize the matrix
        normalized_matrix = actual_matrix / actual_matrix.sum(axis=0)
        # Calculate the average of each row
        weights = normalized_matrix.mean(axis=1)
    elif method == "eigenvector":
        # Calculate the eigenvalues and eigenvectors
        eigenvalues, eigenvectors = np.linalg.eig(actual_matrix)
        # Find the index of the maximum eigenvalue
        max_index = np.argmax(eigenvalues)
        # Get the corresponding eigenvector
        weights = np.real(eigenvectors[:, max_index])
    else:
        raise ValueError("Method must be 'average' or 'eigenvector'.")

    # Normalize the weights
    weights /= weights.sum()

    # Round the weights to preserve the sum
    weights = round_preserve_sum(weights, 3)

    return weights


def matrix_to_table(matrix: np.ndarray, attributes: list) -> list:
    """
    Convert a square matrix to a table that can be displayed in Quarto.

    Args:
        matrix (np.ndarray): The square matrix to convert.
        attributes (list): The list of attribute names corresponding to the matrix.
    Returns:
        list: A table representation of the matrix with attributes as headers.
    """
    table = []
    header = ["Attribute"] + attributes
    table.append(header)

    for i, row in enumerate(matrix):
        table_row = [attributes[i]] + list(
            map(lambda w: f"1/{-w}" if w < 0 else str(w), row.tolist())
        )
        table.append(table_row)

    return table


def show_table(table: list):
    colalign = ["left"] + ["center"] * (len(table[0]) - 1)
    return tabulate(table, headers="firstrow", tablefmt="html", colalign=colalign)


def main():

    attributes = [
        "Encasement",
        "Visibility",
        "Walking/biking accessibility to streams",
        "Walking/biking accessibility to green spaces",
        "Land use variety",
    ]

    saaty_matrix = np.array(
        [
            [1, 2, -3, -3, -2],
            [-2, 1, -4, -4, -2],
            [3, 4, 1, -2, 3],
            [3, 4, 2, 1, 1],
            [2, 2, -3, 1, 1],
        ]
    )

    # Calculate the weights
    weights = calculate_weights(saaty_matrix)

    # Convert the matrix to a table
    table = matrix_to_table(saaty_matrix, attributes)

    # Show the table
    show_table(table)


if __name__ == "__main__":
    main()
