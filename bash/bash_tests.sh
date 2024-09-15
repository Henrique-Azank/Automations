
# Setting up the script to run in bash ----------

# Shebang line (more scalable version)
#!/usr/bin/env bash

# Set the behavior for the script
# -e: Exit immediately if a command exits with a non-zero status
# -o: Prevent errors in a pipeline from being masked
# -u: Treat unset variables as an error when substituting
set -eou pipefail

# Conditional for verifying the existance of a variable ----------

# NOTE: no spaces allowed between the variable name and the equal sign
some_variable=""

# conditionals are always in square brackets
# -z: checks if the variable is empty
# -n: checks if the variable is not empty
if [ -z "$some_variable" ]; then
  echo "The variable is empty (verified with -z)"
else
  echo "The variable is not empty (verified with -z)"
fi

if [ -n "$some_variable" ]; then
  echo "The variable is not empty (verified with -n)"
else
  echo "The variable is empty (verified with -n)"
fi

# Conditional with user input ----------

# Permanent while loop
while true; do

  # Example of reading user input into a variable
  echo "Enter a value: "
  read -r some_variable
  echo "You entered: $some_variable, are you satisfied with this value? (y/n)"
  read -r satisfied

  # Convert the input to lowercase (just so Y and y are acceptable)
  if [[ "${satisfied,,}" == "y" ]]; then
    echo "Great! You are satisfied with the value"
    break
  else
    some_variable=""
  fi
done



