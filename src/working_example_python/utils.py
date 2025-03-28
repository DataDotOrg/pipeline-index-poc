import pandas as pd

def read_data_file(file_path: str, delimiter: str = ',', column_names: list = None):
    """
    Reads a data file into a pandas DataFrame with error handling.
    
    :param file_path: Path to the data file.
    :param delimiter: Delimiter used in the file (default is comma).
    :param column_names: Optional list of column names if no header is present.
    :return: DataFrame or None if an error occurs.
    """
    try:
        df = pd.read_csv(file_path, sep=delimiter, header=None if column_names else 'infer', names=column_names)
        return df
    except FileNotFoundError:
        print(f"Error: '{file_path}' not found.")
    except pd.errors.EmptyDataError:
        print(f"Error: '{file_path}' is empty.")
    except Exception as e:
        print(f"An error occurred: {e}")
    
    return df
