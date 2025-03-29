#!/bin/sh

rm -rf ./bin
mkdir -p ./bin

cargo -Zbuild-std=std,panic_abort -Zbuild-std-features=panic_immediate_abort build --manifest-path ./src/typsium-rs/Cargo.toml --release --target wasm32-unknown-unknown

du -h ./src/typsium-rs/target/wasm32-unknown-unknown/release/typsium_rs.wasm

wasm-opt ./src/typsium-rs/target/wasm32-unknown-unknown/release/typsium_rs.wasm \
    -o ./bin/plugin.wasm \
    -O3 \
    --flatten \
    --rereloop \
    -Oz \
    -c \

du -h ./bin/plugin.wasm