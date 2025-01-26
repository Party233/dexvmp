#!/bin/bash

install_dir=$HOME
sdk_dir=$install_dir/android-sdk
cmake_dir=$sdk_dir/cmake
ndk_dir="$sdk_dir/ndk"
ndk_file_name="android-ndk.tar.zst"
ndk_url="https://github.com/Party233/dexvmp/releases/download/android-ndk-r25c-ollvm/$ndk_file_name"
ndk_installed=false
cmake_installed=false

run_install_cmake() {
	download_cmake 3.10.2
	download_cmake 3.18.1
	download_cmake 3.22.1
	download_cmake 3.25.1
}

download_cmake() {
	cmake_version=$1
	cmake_path="$cmake_dir/$cmake_version"
	if [ -d "$cmake_path" ]; then
		echo "CMake $cmake_version already exists. Deleting..."
		rm -rf "$cmake_path"
	fi
	echo "Downloading CMake $cmake_version..."
	wget https://github.com/MrIkso/AndroidIDE-NDK/releases/download/cmake/cmake-"$cmake_version"-android-aarch64.zip --no-verbose --show-progress -N
	installing_cmake "$cmake_version"
}

installing_cmake() {
	cmake_version=$1
	cmake_file=cmake-"$cmake_version"-android-aarch64.zip

	if [ -f "$cmake_file" ]; then
		echo "Unzipping CMake $cmake_version..."
		unzip -qq "$cmake_file" -d "$cmake_dir"
		rm "$cmake_file"
		chmod -R +x "$cmake_dir"/"$cmake_version"/bin
		cmake_installed=true
	else
		echo "$cmake_file does not exist."
	fi
}

install_ndk() {
	echo "Downloading NDK..."
	wget "$ndk_url" --no-verbose --show-progress -N
	if [ -f "$ndk_file_name" ]; then
		echo "Extracting NDK..."
		mkdir -p "$ndk_dir"
		tar --zstd -xf "$ndk_file_name" -C "$ndk_dir"
		rm "$ndk_file_name"
		ndk_installed=true
	else
		echo "Failed to download $ndk_file_name."
	fi
}

echo "Installing NDK and CMake..."
install_ndk

if [ -d "$cmake_dir" ]; then
	cd "$cmake_dir"
	run_install_cmake
else
	mkdir -p "$cmake_dir"
	cd "$cmake_dir"
	run_install_cmake
fi

if [[ $ndk_installed == true && $cmake_installed == true ]]; then
	echo 'Installation Finished!'
else
	echo 'Failed to install NDK and/or CMake.'
fi