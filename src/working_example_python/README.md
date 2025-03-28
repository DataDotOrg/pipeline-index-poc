# Kaplan-Meier Survival Analysis with Lifelines

This repository contains a Python script for performing Kaplan-Meier survival analysis using the `lifelines` library. It takes a data file as input and generates a CSV file containing the survival function and related statistics. The repository also includes instructions for validating the output CSV file against a defined schema using the Frictionless Data framework.

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd <repository_name>
    ```

2.  **Install necessary libraries:**
    ```bash
    pip install pandas lifelines frictionless
    ```

## Usage

### 1. Generating the Output CSV

The `lifelines_KaplanMeierFitter_python.py` script takes a data file as a command-line argument. The script assumes the data file contains at least two columns: one for survival time and another for the event status. By default, it expects these columns to be named `t` and `status`, respectively. You can override these defaults using command-line arguments.
The actual data file can be found [here](https://github.com/pzivich/zEpid/blob/master/zepid/datasets/leukemia.dat)

To generate the `output.csv` file, execute the following command in your terminal:

```bash
python3 lifelines_KaplanMeierFitter_python.py leukemia.dat


### 2. Validating the Schema using Frictionless

To validate the `output.csv` file against the schema, use the following command in your terminal:

```bash
frictionless validate --schema lifelines_KaplanMeierFitter_python.output.schema.yaml output.csv

### Expected Output
──────────────────────────────────────────────────────────── Dataset ─────────────────────────────────────────────────────────────
                  dataset

┏━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━┓
┃ name   ┃ type  ┃ path       ┃ status ┃
┡━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━┩
│ output │ table │ output.csv │ VALID  │
└────────┴───────┴────────────┴────────┘