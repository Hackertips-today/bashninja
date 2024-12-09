


#!/bin/bash

# Input JSON (encoded with HTML entities)
JSON='>{&#34;at&#34;: &#34;True&#34;, &#34;ga4&#34;: [{&#34;id&#34;: &#34;G-272J68FCRF&#34;, &#34;purpose&#34;: 1}, {&#34;id&#34;: &#34;G-P65P8J8YWQ&#34;, &#34;purpose&#34;: 0}], &#34;ga4p&#34;: [{&#34;id&#34;: &#34;G-272J68FCRF&#34;, &#34;purpose&#34;: 1}], &#34;gtm&#34;: [], &#34;parameters&#34;: {&#34;internalUser&#34;: &#34;False&#34;, &#34;language&#34;: {&#34;machineTranslated&#34;: &#34;False&#34;, &#34;requested&#34;: &#34;en&#34;, &#34;served&#34;: &#34;en&#34;}, &#34;pageType&#34;: &#34;article&#34;, &#34;projectName&#34;: &#34;Google for Developers&#34;, &#34;signedIn&#34;: &#34;False&#34;, &#34;tenant&#34;: &#34;developers&#34;, &#34;recommendations&#34;: {&#34;sourcePage&#34;: &#34;&#34;, &#34;sourceType&#34;: 0, &#34;sourceRank&#34;: 0, &#34;sourceIdenticalDescriptions&#34;: 0, &#34;sourceTitleWords&#34;: 0, &#34;sourceDescriptionWords&#34;: 0, &#34;experiment&#34;: &#34;&#34;}, &#34;experiment&#34;: {&#34;ids&#34;: &#34;&#34;}}}'

# Step 1: Decode HTML entities
DECODED_JSON=$(echo "$JSON" | sed 's/&#34;/"/g' | sed 's/>//')

# Step 2: Pretty-print the JSON using jq
echo "$DECODED_JSON" | jq .

  ---
  {
  "at": "True",
  "ga4": [
    {
      "id": "G-272J68FCRF",
      "purpose": 1
    },
    {
      "id": "G-P65P8J8YWQ",
      "purpose": 0
    }
  ],
  "ga4p": [
    {
      "id": "G-272J68FCRF",
      "purpose": 1
    }
  ],
  "gtm": [],
  "parameters": {
    "internalUser": "False",
    "language": {
      "machineTranslated": "False",
      "requested": "en",
      "served": "en"
    },
    "pageType": "article",
    "projectName": "Google for Developers",
    "signedIn": "False",
    "tenant": "developers",
    "recommendations": {
      "sourcePage": "",
      "sourceType": 0,
      "sourceRank": 0,
      "sourceIdenticalDescriptions": 0,
      "sourceTitleWords": 0,
      "sourceDescriptionWords": 0,
      "experiment": ""
    },
    "experiment": {
      "ids": ""
    }
  }
}




