rm -rf build/app/outputs/apk/release/*
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
name=$(cat pubspec.yaml | yq e '.name' -)
version=$(cat pubspec.yaml | yq e '.version' -)
now_stamp=$(date +%s%3)
cd build/app/outputs/apk/release
mv app-arm64-v8a-release.apk ${name}_v${version}_64bit_${now_stamp}.apk
mv app-armeabi-v7a-release.apk ${name}_v${version}_32bit_${now_stamp}.apk
