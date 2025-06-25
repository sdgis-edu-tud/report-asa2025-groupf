# Unpacking Dresden

[![CC BY 4.0][cc-by-shield]][cc-by]

## Purpose of the Project

### Context

Along with the Elbe river, Dresden comprises a dense network of streams, which are spread out across its fabric. Presently, the streams are secluded from being a valuable part of the city. The problems are characterised by ecological issues, inappropriate land use by residents, and artificial channeling. They, along with the Elbe river hold potential to become elements of integrating the ecological and social functions of the city by reclaiming the historical identity of waterfronts and restoring natural habitats. Therefore, there arises a need to understand how to integrate these streams into the network of protected green areas and public spaces, while maximising their contribution to biodiversity while adapting to the risk of flooding within and around the city.

### Research Questions

These concerns and identified potentials beg the question that, **how can urban streams be restored and integrated in Dresden's fabric, such that there is a synergy between human activities and the natural environment?**

This is investigated by adopting an integrated approach for **biodiversity**, **climate adaptation** and **quality of life**. For each of these topics, a sub-research question was derived:

- Biodiversity: What are the potentials and current urgencies in the integration of the natural elements in the urban landscape of Dresden?
- Climate Adaptation: What are the main challenges and the potential spatial interventions to adapt to climate change?
- Quality of Life: How accessible, inviting, and diverse is Dresden's public space, and how can it reach its full potential?

### Analysis Method

Based on the three criteria that we decided to tackle, we came up with numerical indicators that we could use to evaluate them. These numerical indicators are called attributes and have to be normalised—in our case between 0 and 1—so that they can be compared, weighted and thereafter clustered properly depending on their relevance and similarities.

The spatial units used in this study are hexagons with a dimension of 250 meters. The study area of Dresden is divided using a complete surface of a hexagonal pattern. Then it is overlaid with the water stream network and river body from OpenStreetMap to keep only the hexagons that intersect with at least one stream. Finally, the isolated hexagons were removed.

Two data-driven methods were used to conduct the analysis:

- **S-MCDA (Spatial Multi-Criteria Decision Analysis)** — S-MCDA was used to weigh the different attributes against each other. The method supports decision-making by evaluating and ranking alternatives (the attributes) within the three objectives of biodiversity, climate adaptation and quality of life.
- **Typology Construction** — Typology construction is used to group attributes into homogenous types based on similarities. This was used to identify patterns in data and make clusters of attributes that show similarity, which can thereafter be used to understand the type of interventions which would be impactful.

## Authors

1. Author 1
   - Name: Adriano Mancini  
   - Institution: TU Delft  
   - Email: <a.mancini-1@student.tudelft.nl>
2. Author 2
   - Name: Alankrita Sharma  
   - Institution: TU Delft  
   - Email: <a.sharma-73@student.tudelft.nl>
3. Author 3
   - Name: Alexandre Bry  
   - Institution: TU Delft  
   - Email: <a.m.e.bry@student.tudelft.nl>
4. Author 4
   - Name: Grase Stephanie Stuka  
   - Institution: TU Delft  
   - Email: <gstuka@student.tudelft.nl>
5. Author 5
   - Name: Soroush Saffarzadeh  
   - Institution: TU Delft  
   - Email: <s.saffarzadeh@student.tudelft.nl>

## Repository Structure

```bash
.
├── data                      # Created layers of data
│   ├── intermediate          # Intermediate layers 
│   └── results               # Final results layers
├── .github
├── .gitignore
├── images                    # Images used in the report
├── index.qmd                 # Main landing page of the report
├── _quarto.yml               # Metadata and settings of the report
├── LICENSE
├── README.md
├── references.bib            # References used in the report
├── requirements.txt          # Requirements for the Python code in the report
├── sections                  # Sections of the report
├── src                       # External R scripts
└── styles.css                # Some styling for the report
```

## Data

The dataset created during this project is available [online](https://doi.org/10.4121/48e04672-93f4-49a4-9c7b-76c57a844e24).

## Software

Software that we used:

- [QGIS](https://qgis.org/download/) (different versions from 3.28 to 3.40 for the different authors) for the data manipulation, analysis and visualisation
- [R](https://cran.rstudio.com/) version 4.5.1 for some data analysis and visualisation in the report
- [Python](https://www.python.org/downloads/) version 3.12 for some visualisation in the report. The dependencies are stored in [`requirements.txt`](requirements.txt).
- [Quarto](https://quarto.org/docs/get-started/) version 1.7.32 to render the report.

## License

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
