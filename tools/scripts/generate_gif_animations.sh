#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

for input_color_folder in images-recolored/units/*; do
    color_suffix=$(basename "$input_color_folder")
    output_color_folder="images-animated/units/${color_suffix}"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-${color_suffix}.png"                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-5-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-6-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-7-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-8-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-9-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-10-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-11-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-12-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-13-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-14-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-15-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-${color_suffix}.png"                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-1-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-2-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-3-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-4-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-5-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-6-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-7-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-8-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-attack-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 100                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-${color_suffix}.png"                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-5-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-6-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-7-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-8-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-9-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-10-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-11-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-12-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-13-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-14-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-15-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-16-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-17-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-18-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-throw-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-0-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-1-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-2-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-3-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-4-${color_suffix}.png"              \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-run-5-${color_suffix}.png"              \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-se-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate                                                                                \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-${color_suffix}.png"       --delay 1200 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-die-1-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-die-2-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-die-3-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-die-4-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-die-5-${color_suffix}.png" --delay 1200 \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-se-die-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-${color_suffix}.png"                 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-1-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-2-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-3-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-4-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-5-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-6-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-7-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-8-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-9-${color_suffix}.png"         \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-10-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-11-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-12-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-13-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-14-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-15-${color_suffix}.png"        \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-stand-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-${color_suffix}.png"                 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-1-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-2-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-3-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-4-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-5-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-6-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-7-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-8-${color_suffix}.png"        \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-9-${color_suffix}.png"        \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-attack-${color_suffix}.gif"

    python -m sprite_manager $@ animate                                                                                     \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-${color_suffix}.png"          --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-1-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-2-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-3-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-4-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-5-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-6-${color_suffix}.png"  --delay 75  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-7-${color_suffix}.png"  --delay 50  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-8-${color_suffix}.png"  --delay 50  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-9-${color_suffix}.png"  --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-10-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-11-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-12-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-13-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-14-${color_suffix}.png" --delay 100 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-15-${color_suffix}.png" --delay 100 \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-throw-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-0-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-1-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-2-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-3-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-4-${color_suffix}.png"           \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-5-${color_suffix}.png"           \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate                                                                                   \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-${color_suffix}.png"       --delay 1200 \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-1-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-2-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-3-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-4-${color_suffix}.png" --delay 200  \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-5-${color_suffix}.png" --delay 1200 \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-ne-die-${color_suffix}.gif"
        
    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-0-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-5-${color_suffix}.png"            \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-s-run-${color_suffix}.gif"

    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-0-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-1-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-2-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-3-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-4-${color_suffix}.png"            \
        --frame "${input_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-5-${color_suffix}.png"            \
        --output "${output_color_folder}/feu-ra/chakram-wielders/chakram-fighter-n-run-${color_suffix}.gif"

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
        --frame "${input_color_folder}/feu-ra/mystics/guru-${color_suffix}.png"                                        \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-1-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-2-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-3-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-4-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-5-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-6-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-7-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-8-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-9-${color_suffix}.png"                                \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-10-${color_suffix}.png"                               \
        --frame "${input_color_folder}/feu-ra/mystics/guru-stand-11-${color_suffix}.png"                               \
        --output "${output_color_folder}/feu-ra/mystics/guru-stand-${color_suffix}.gif"


    python -m sprite_manager $@ animate --delay 200                                                                    \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-${color_suffix}.png"                                   \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-1-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-2-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-3-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-4-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-5-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-6-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-7-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-8-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-9-${color_suffix}.png"                           \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-10-${color_suffix}.png"                          \
        --frame "${input_color_folder}/feu-ra/mystics/maharishi-stand-11-${color_suffix}.png"                          \
        --output "${output_color_folder}/feu-ra/mystics/maharishi-stand-${color_suffix}.gif"

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
 
done

python -m sprite_manager $@ animate --delay 200                                                                        \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-1.png                                                                           \
    --frame images/projectiles/chakram-0.png                                                                           \
    --frame images/projectiles/chakram-2.png                                                                           \
    --output images-animated/projectiles/chakram.gif
