require 'yaml'

# create a fact for gathering the puppetmaster IP from the hosts file
Facter.add("dogae_appengine_version") do
  setcode "curl -v --silent https://cloud.google.com/appengine/downloads 2>&1 | grep '<td>1.9.' | sed -e 's/ //g' -e 's/<td>//g' | awk -F'-' ' { print $1; } ' | uniq"
end

