#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"

python -m sprite_manager kra -i :/images-kra/exports -o :/images --recursive


python -m sprite_manager recolor -i :/images/units -o :/images-recolored/units                                         \
    --color-suffixes --color-folders --recursive                                                                       \
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


python -m sprite_manager recolor -i :/images/halo/mystic-sensed -o :/images-recolored/halo/mystic-sensed               \
    --color-suffixes --color-folders --recursive                                                                       \
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


python -m sprite_manager animate -i :/json-animations --recursive
