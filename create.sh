if [ -z "$1" ]; then
    echo "Enter plugin package name"
    exit
fi

# Create Package
poetry init
mkdir $1
gsed -i -e "/\[tool\.poetry\]/a\packages = [\n    { include = \"$1\" },\n]" pyproject.toml

poetry add bandit black invoke \
        pylint pylint-django \
        pydocstyle yamllint --dev

# Copy task.py develompment for ntc-netbox-plugin-onboarding.git
git clone https://github.com/networktocode/ntc-netbox-plugin-onboarding.git
cp ./ntc-netbox-plugin-onboarding/tasks.py ./
cp -r ./ntc-netbox-plugin-onboarding/development ./development
rm -rf ./ntc-netbox-plugin-onboarding

# Insert package name in configuration.py
gsed -i -e "s/netbox_onboarding/$1/" development/configuration.py
gsed -i -e "s/PLUGINS\_CONFIG \= {}/PLUGINS\_CONFIG \= {\"$1\"\: {}}/" development/configuration.py
