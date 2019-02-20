current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parent_dir="$(dirname "$current_dir")"
atom_dir="$parent_dir/atom"

mkdir -p $atom_dir
mkdir -p ~/.atom

echo Installing atom packages ...
apm install --packages-file $atom_dir/packages.txt

echo Adding snippets, bindings, styles and setting config...

rm ~/.atom/keymap.cson
cp $atom_dir/keymap.cson ~/.atom/

rm ~/.atom/styles.less
cp $atom_dir/styles.less ~/.atom/

rm ~/.atom/init.coffee
cp $atom_dir/init.coffee ~/.atom/

rm ~/.atom/snippets.cson
cp $atom_dir/snippets.cson ~/.atom/

rm ~/.atom/config.cson
cp $atom_dir/config.cson ~/.atom/

echo Adding personal file icons...

cp $atom_dir/personal-atom-file-icons/* ~/.atom/packages/atom-file-icons/icons
cp $atom_dir/atom-file-icons.less ~/.atom/packages/atom-file-icons/styles

echo All Done!
