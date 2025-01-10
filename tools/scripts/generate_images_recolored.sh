#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

python -m sprite_manager $@ recolor -i :/images/units -o :/images-recolored/units --color-suffixes --color-folders     \
    --from magenta,cyan                                                                                                \
    --to red,indianyellow                                                                                              \
    --to blue,indianyellow                                                                                             \
    --to green,indianyellow                                                                                            \
    --to purple,indianyellow                                                                                           \
    --to black,indianyellow                                                                                            \
    --to brown,indianyellow                                                                                            \
    --to orange,indianyellow                                                                                           \
    --to white,indianyellow                                                                                            \
    --to teal,indianyellow                                                                                             \
    --to lightred,indianyellow                                                                                         \
    --to darkred,indianyellow                                                                                          \
    --to lightblue,indianyellow                                                                                        \
    --to brightgreen,indianyellow                                                                                      \
    --to brightorange,indianyellow                                                                                     \
    --to gold,indianyellow                                                                                             \
    --to red,indigo                                                                                                    \
    --to blue,indigo                                                                                                   \
    --to green,indigo                                                                                                  \
    --to purple,indigo                                                                                                 \
    --to black,indigo                                                                                                  \
    --to brown,indigo                                                                                                  \
    --to orange,indigo                                                                                                 \
    --to white,indigo                                                                                                  \
    --to teal,indigo                                                                                                   \
    --to lightred,indigo                                                                                               \
    --to darkred,indigo                                                                                                \
    --to lightblue,indigo                                                                                              \
    --to brightgreen,indigo                                                                                            \
    --to brightorange,indigo                                                                                           \
    --to gold,indigo                                                                                                   \
    --to red,skyblue                                                                                                   \
    --to blue,skyblue                                                                                                  \
    --to green,skyblue                                                                                                 \
    --to purple,skyblue                                                                                                \
    --to black,skyblue                                                                                                 \
    --to brown,skyblue                                                                                                 \
    --to orange,skyblue                                                                                                \
    --to white,skyblue                                                                                                 \
    --to teal,skyblue                                                                                                  \
    --to lightred,skyblue                                                                                              \
    --to darkred,skyblue                                                                                               \
    --to lightblue,skyblue                                                                                             \
    --to brightgreen,skyblue                                                                                           \
    --to brightorange,skyblue                                                                                          \
    --to gold,skyblue                                                                                                  \
    --to red,red                                                                                                       \
    --to blue,blue                                                                                                     \
    --to green,green                                                                                                   \
    --to purple,purple                                                                                                 \
    --to black,black                                                                                                   \
    --to brown,brown                                                                                                   \
    --to orange,orange                                                                                                 \
    --to white,white                                                                                                   \
    --to teal,teal                                                                                                     \
    --to lightred,lightred                                                                                             \
    --to darkred,darkred                                                                                               \
    --to lightblue,lightblue                                                                                           \
    --to brightgreen,brightgreen                                                                                       \
    --to brightorange,brightorange                                                                                     \
    --to gold,gold                                                                                                     \

python -m sprite_manager $@ recolor -i :/images/halo/mystic-sensed -o :/images-recolored/halo/mystic-sensed            \
    --color-suffixes --color-folders                                                                                   \
    --from magenta                                                                                                     \
    --to red                                                                                                           \
    --to blue                                                                                                          \
    --to green                                                                                                         \
    --to purple                                                                                                        \
    --to black                                                                                                         \
    --to brown                                                                                                         \
    --to orange                                                                                                        \
    --to white                                                                                                         \
    --to teal                                                                                                          \
    --to lightred                                                                                                      \
    --to darkred                                                                                                       \
    --to lightblue                                                                                                     \
    --to brightgreen                                                                                                   \
    --to brightorange                                                                                                  \
    --to gold                                                                                                          \

for input_color_folder in images-recolored/units/*; do
    color_suffix=$(basename "$input_color_folder")

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-${color_suffix}.png"                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-5-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-6-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-7-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-8-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-9-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-10-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-11-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-12-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-13-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-14-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-15-${color_suffix}.png"           \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 100                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-${color_suffix}.png"                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-5-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-6-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-7-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-8-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-9-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-10-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-11-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-12-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-13-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-14-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-15-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-16-${color_suffix}.png"           \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-0-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-1-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-2-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-3-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-4-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-5-${color_suffix}.png"              \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-se-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-${color_suffix}.png"                 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-1-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-2-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-3-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-4-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-5-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-6-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-7-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-8-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-9-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-10-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-11-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-12-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-13-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-14-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-15-${color_suffix}.png"        \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-0-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-1-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-2-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-3-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-4-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-5-${color_suffix}.png"           \
        --output "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-${color_suffix}.png"                                     \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-1-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-2-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-3-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-4-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-5-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-6-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-7-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-8-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-9-${color_suffix}.png"                             \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-10-${color_suffix}.png"                            \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-11-${color_suffix}.png"                            \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-12-${color_suffix}.png"                            \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-13-${color_suffix}.png"                            \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-14-${color_suffix}.png"                            \
        --frame "${input_color_folder}/feu-ra/mystics/seer-ne-stand-15-${color_suffix}.png"                            \
        --output "${input_color_folder}/feu-ra/mystics/seer-ne-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 1600                                                                   \
        --frame "${input_color_folder}/feu-ra/mystics/seer-${color_suffix}.png"                                        \
        --frame "${input_color_folder}/feu-ra/mystics/seer-stand-1-${color_suffix}.png"                                \
        --output "${input_color_folder}/feu-ra/mystics/seer-stand-${color_suffix}.gif"
done

python -m sprite_manager $@ animate --delay 200                                                                        \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-1.png                                                                           \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-2.png                                                                           \
    --output images-recolored/projectiles/chakram.gif
