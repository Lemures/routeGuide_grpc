# Use this only if you have 1 proto buf file.
name=`find . -name "*.proto" -exec basename {} .proto \;`
find . -name "*.proto" | xargs protoc -I "." -o "$name.desc"
