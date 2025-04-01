import pandas as pd
from lifelines import KaplanMeierFitter
import matplotlib.pyplot as plt
from utils import read_data_file
import os 
import argparse

# os.chdir('/Users/avinashladdha/___PROJECTS/pipeline-index-poc/src/working_example_python')


def get_kmf_stats_dataframe(durations, event_observed, label='KM Estimate', alpha=0.05):
    """
    Fits a Kaplan-Meier model and returns key statistics as rows of a pandas DataFrame.

    Args:
        durations (pd.Series): A pandas Series of survival times.
        event_observed (pd.Series): A pandas Series of boolean or binary event indicators (True/1 if event occurred, False/0 if censored).
        label (str, optional): Label for the survival curve. Defaults to 'KM Estimate'.
        alpha (float, optional): Significance level for confidence intervals (e.g., 0.05 for 95% CI). Defaults to 0.05.

    Returns:
        pd.DataFrame: 
            - Survival Probability: The Kaplan-Meier survival function.
     """
    kmf = KaplanMeierFitter(label=label, alpha=alpha)
    kmf.fit(durations=durations, event_observed=event_observed)

    survival_function_df = kmf.survival_function_.rename(columns={label: 'Survival Probability'})
    confidence_interval_df = kmf.confidence_interval_

    median_survival_time = kmf.median_survival_time_
    median_ci = kmf.confidence_interval_survival_function_.loc[[median_survival_time]].values[0] if median_survival_time != float('inf') else [float('inf'), float('inf')]


    survival_function_df = pd.DataFrame(survival_function_df).reset_index()
    survival_function_df.columns = ['time', 'survival_probability']
    return survival_function_df



if __name__ == '__main__':
    
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Perform Kaplan-Meier analysis.")
    parser.add_argument("file_path", help="Path to the file containing survival data.")
    args = parser.parse_args()

    csv_path = args.file_path
    
    
    
    
    try:
        df = read_data_file(csv_path,delimiter=' ')
        kmf_stats_df = get_kmf_stats_dataframe(df['t'], df['status'])

        kmf_stats_df['time'] = kmf_stats_df['time'].astype(int)
        kmf_stats_df['survival_probability'] = kmf_stats_df['survival_probability'].astype(float)

        kmf_stats_df.to_csv('output.csv', index=False)
        print("Kaplan-Meier analysis completed successfully")
    except FileNotFoundError:
        print(f"Error: File not found at path: {csv_path}")
    except Exception as e:
        print(f"An error occurred while reading the CSV file: {e}")