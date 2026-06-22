import sys
import os

def remove_and_replace_lines(input_file, output_file, phrases, replacements):
    # Check if the input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file {input_file} does not exist.")
        sys.exit(1)

    # Check if the output file exists, if yes, remove it
    if os.path.exists(output_file):
        print(f"{output_file} exists, removing it.")
        os.remove(output_file)
    else:
        print(f"{output_file} does not exist, creating it.")

    # Open input file for reading and output file for writing
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        line_number = 1
        for line in infile:
            line = line.strip()  # Remove leading/trailing whitespaces

            # Check if the line contains any of the specified phrases
            match = False
            for phrase in phrases:
                if phrase in line:
                    match = True
                    break

            # If no match, proceed to copy and apply replacements
            if not match:
                # Apply all the replacements to the line
                for old, new in replacements.items():
                    if old in line:
                        line = line.replace(old, new)

                print(f"Copying line {line_number}: {line}")
                outfile.write(line + '\n')

            line_number += 1

    print(f"Lines containing the specified phrases have been removed from {input_file}, and the required replacements have been made, saved to {output_file}.")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} input_file output_file")
        sys.exit(1)

    # Get input and output file names from the command-line arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Define the list of phrases to exclude lines that contain them
    phrases = [
        "set_max_delay",
        "set_min_delay",
        "set_ideal_network",
        "group_path",
        "set_timing_derate",
        "set_units"
    ]

        ##"set_multicycle_path"

    # Define the replacement mappings
    replacements = {
        "reg/CK]": "reg/CLK]",
        "rtl_top_interface_inst": "interface_inst",
        "clocked_on]": "CLK]"
    }

    # Call the function to process the files
    remove_and_replace_lines(input_file, output_file, phrases, replacements)
