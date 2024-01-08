#!/bin/sh

# Get the GitHub token and Giphy API key from GitHub Actions inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

# Get the pull request number from the GitHub event payload
pr_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo PR number - $pr_number

# Use the Giphy API to fetch a random Thank you GIF
giphy_response=$(curl -s "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you%rating=g")
echo Giphy response - $giphy_response

# Extract the GIF url from the Giphy response
gir_url=$(echo "giphy_response" | jq --raw-output .data.images.downsized.url)

# Comment with the GIF on the pull request
comment_response=$(curl -sX POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -d "{\"body\": \"### PR - #$pr_number. \n ### Thank you for this contribution! \n ![GIF]($gif_url) \'
    "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pr_number/comments")

# Extract and print the comment url from the response
comment_url=$(echo "$comment_response" | jq --raw-outpu .html_url)
