#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

for input_color_folder in images-recolored/units/*; do
    color_suffix=$(basename "$input_color_folder")
    output_color_folder="images-animated/units/${color_suffix}"

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
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-stand-${color_suffix}.gif"

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
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-17-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-18-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-throw-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-0-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-1-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-2-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-3-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-4-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-run-5-${color_suffix}.png"              \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-se-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate                                                                                \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-${color_suffix}.png"       --delay 1200 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-die-1-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-die-2-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-die-3-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-die-4-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-die-5-${color_suffix}.png" --delay 1200 \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-se-die-${color_suffix}.gif"

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
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-0-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-1-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-2-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-3-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-4-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-5-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-${color_suffix}.png"                 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-1-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-2-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-3-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-4-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-5-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-6-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-7-${color_suffix}.png"        \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-attack-${color_suffix}.gif"

    python -m sprite_manager $@ animate                                                                                     \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-${color_suffix}.png"          --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-1-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-2-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-3-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-4-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-5-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-6-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-7-${color_suffix}.png"  --delay 50  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-8-${color_suffix}.png"  --delay 50  \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-9-${color_suffix}.png"  --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-10-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-11-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-12-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-13-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-14-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-15-${color_suffix}.png" --delay 100 \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-ne-throw-${color_suffix}.gif"

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
        --output "${output_color_folder}/feu-ra/mystics/seer-ne-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 1600                                                                   \
        --frame "${input_color_folder}/feu-ra/mystics/seer-${color_suffix}.png"                                        \
        --frame "${input_color_folder}/feu-ra/mystics/seer-stand-1-${color_suffix}.png"                                \
        --output "${output_color_folder}/feu-ra/mystics/seer-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-${color_suffix}.png"                       \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-1-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-2-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-3-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-4-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-5-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-6-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-7-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-8-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-9-${color_suffix}.png"               \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-10-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-11-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-12-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-13-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-14-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-15-${color_suffix}.png"              \
        --output "${output_color_folder}/feu-ra/rope-manipulators/rope-bender-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-0-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-5-${color_suffix}.png"            \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-s-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-0-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-5-${color_suffix}.png"            \
        --output "${output_color_folder}/feu-ra/chakram-warriors/chakram-thrower-n-run-${color_suffix}.gif"
 
done

python -m sprite_manager $@ animate --delay 200                                                                        \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-1.png                                                                           \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-2.png                                                                           \
    --output images-animated/projectiles/chakram.gif
