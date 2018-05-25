cp config/secrets.yml.template config/secrets.yml
printf "export SECRET_KEY_BASE_DEV=" >> secrets
rake secret >> secrets
source ./secrets
rm ./secrets

