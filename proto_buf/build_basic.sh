# Simple basic proto buf gen.
# This is a indiscriminate proto buf build shell script.
# if you have multile proto files that shared in the same package then this is not recommended
# deffer to Build.sh and change the text the bottom.


# Find all proto file and add to an Array
# Extracts only the names without the extention
names=( $(find ./proto_single -name "*.proto" -exec basename {} .proto \;))

# loop through each name and create the *.desc file.
for name in ${names[@]}
do
  find "./proto_single" -name "*.proto" | xargs protoc -I "./proto_single" -o "$name.desc"
done
