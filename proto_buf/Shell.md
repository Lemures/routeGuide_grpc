# Build Shell breakdown

There are Three Build Shells in this Dir but you only need to run 1 of them but it's important to know there difference.

Starting with the `Build_basic.sh` this script is design to be indiscriminate. It is best not to use this if you have broken your Proto buff package into multiple files. Executing this on such project will lead to several `*.desc` with different names but duplicate content.

_`Build_basic.sh` might be slightly different then example below_

```
names=( $(find . -name "*.proto" -exec basename {} .proto \;))
for name in ${names[@]}
do
  find "." -name "*.proto" | xargs protoc -I "./proto" -o "$name.desc"
done
```

This should be basic enough by viewing it what it does but just to explain.

```
names=( $(find . -name "*.proto" -exec basename {} .proto \;))
```

This line finds all proto file and add to an Array, extracts only the names without the extensions.

```
for name in ${names[@]}
do
  find "." -name "*.proto" | xargs protoc -I "./proto" -o "$name.desc"
done
```

loop through each name and create the `*.desc` file.

Continuing to `build.sh` this shell relies on a input to split up the `*.desc`. This would be the recommended way for larger project.

```
function panic(){
  echo $A >&2
  exit 1
}


protoc --version &>/dev/null || panic protoc is required.
output=(`protoc --version`)
version=${output[1]}
IFS=. read major minor patch <<<$version
if [[ $major -lt 3 ]]; then
  panic expect protoc 3.0.0+ but got $version.
fi
```

Block above provides error feed back and version checking also is optional. So long as you know that `protoc` is install and is version 3+. In a team or opensource environment just good to have.

The rest of the script generates the `*.desc` files.

```

rootdir=`dirname $0`

while read include package name; do
  prefix="$rootdir/proto/$package"
  include="$rootdir/proto/$include"
  echo building $name.desc
find "$prefix" -name "*.proto" | xargs protoc -I "$include" -o "$rootdir/$name.desc"
done <<EOF
. testing testing
. . route_guide
EOF
```

``rootdir=`dirname $0` `` as the variable states gets the root

Before explaining `while` loop it would be best if I explain the text at the bottom nest between the `EOF`

So the first shell as I said was indiscriminate. If it found a `*.proto` file it'll generate a `*.desc`. this fine if interface descriptions for that package are able to be fitted into one file.

For cases where you have a package broken up into several files but share the same package name i.e. `package testing;`. It would be covenant to have the shell only generate `testing.desc` needed rather than have it create 6 different named files with identical content. less cleanup work for us is always welcomed.

So getting to the point using some external text cherry-pick help us here.

```
. grpc/testing testing
. . route_guide
EOF
```

Now `while read include package name;` using the text above each line gets feed into the `include`, `package` and `name`. The two important vars are `Package` and `name`, in most cases `include` = `.` would be fine.

using `. grpc/testing testing` as the source for one of the loops. This example code has been slightly altered so this could be ran as a shell script.

```
rootdir=`dirname $0`

include="."
package="grpc/testing"
name="testing"

prefix="$rootdir/proto/$package"
include="$rootdir/proto/$include"
echo building $name.desc
find "$prefix" -name "*.proto" | xargs protoc -I "$include" -o "$rootdir/$name.desc"
```

This should create a new file `testing.desc` where the shell is located.

```
# error & version check snip

# while loop with read instructions
  #do stuff snip
  #done <<EOF

. grpc/testing testing
. . route_guide
EOF
```

alternatively you can remove everything from `<<EOF` down and add text to a `.txt` file. So now in the terminal you should just need to enter `./build_extern.sh << proto-build.txt`

**Note I made a build shell for extern files.**

incidentally if the shell generates a file that looks like this `testing.desc` it mean the `.txt` isn't in UNIX. In terminal `dos2unix proto-build.txt` will fix that problem for next time you run the `build_extern.sh`
