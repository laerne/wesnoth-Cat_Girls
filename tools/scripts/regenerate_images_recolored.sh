#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

rm -r images-recolored/
python -m sprite_manager recolor -i :/images/units -o :/images-recolored/units --color-suffixes --color-folders        \
    --from magenta,cyan                                                                                                \
    --to red,indianyellow                                                                                              \
    --to blue,indianyellow                                                                                             \
    --to green,indigo                                                                                                  \
    --to purple,indianyellow                                                                                           \
    --to black,indianyellow                                                                                            \
    --to brown,skyblue                                                                                                 \
    --to orange,skyblue                                                                                                \
    --to white,white                                                                                                   \
    --to teal,indianyellow                                                                                             \
    --to lightred,skyblue                                                                                              \
    --to darkred,indianyellow                                                                                          \
    --to lightblue,indianyellow                                                                                        \
    --to brightgreen,indigo                                                                                            \
    --to brightorange,skyblue                                                                                          \
    --to gold,indigo

for input_color_folder in images-recolored/units/*; do
    color_suffix=$(basename "$input_color_folder")

    python -m sprite_manager animate --delay 200                                                                       \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-base-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand1-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand2-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand3-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand4-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand5-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand6-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand7-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand8-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand9-${color_suffix}.png"             \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand10-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand11-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand12-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand13-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand14-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand15-${color_suffix}.png"            \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-${color_suffix}.gif"

    python -m sprite_manager animate --delay 200                                                                       \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run0-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run1-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run2-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run3-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run4-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run5-${color_suffix}.png"               \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-${color_suffix}.gif"
done

