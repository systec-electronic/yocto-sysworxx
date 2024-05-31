# serialize nodejs linking to save RAM (https://github.com/nodejs/node/issues/45949)
EXTRA_OEMAKE:append = "LINK='flock /tmp ${CXX}'"