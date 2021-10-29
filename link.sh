#!bash

# See {@link https://cloud.google.com/datastore/docs/concepts/overview| Cloud Datastore Concepts Overview}

# @see [Cloud Datastore Concepts Overview]{@link https://cloud.google.com/datastore/docs/concepts/overview}


sed -i -e 's/@see \[\(.*\)\]{@link \(.*\)}$/See {@link \2| \1}/' src/*

