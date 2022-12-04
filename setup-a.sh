dir_path="Preferences/*"
dirs="find $dir_path"

for dir in $dirs;
do
    file_name=$(basename $dir)
    eval "defaults import ${base_name//.plist/} $dir"
done

defaults import .GlobalPreferences Preferences/.GlobalPreferences.plist
