
# Display all unicode chars and codes

#!/bin/bash

# Starting Unicode point
start_point=0x0000

# Function to URL encode the character
url_encode() {
  local char=$1
  printf "%%%02X" "'$char"
}

# Function to print 500 Unicode characters
print_chars() {
  local start=$1
  local count=0

  echo -e "\nDisplaying Unicode characters from $(printf 'U+%04X' "$start")"

  # Loop through Unicode points, 500 at a time
  for (( i=$start; count<500; i++ )); do
    # Get the string name (hex) and character
    char=$(printf '\\U%08X' "$i")
    hex_name=$(printf 'U+%04X' "$i")
    
    # Extract actual character (avoiding escape sequences)
    real_char=$(printf "%b" "$char")
    
    # URL encode the character
    url_encoded=$(url_encode "$real_char")
    
    # Check if the character is printable or replace with placeholder
    if [[ "$real_char" =~ [[:print:]] ]]; then
      printf "%-12s %-2s %-12s " "$hex_name" "$real_char" "$url_encoded"
    else
      printf "%-12s %-2s %-12s " "$hex_name" "�" "$url_encoded"  # Replacement character for missing glyphs
    fi

    # Print 4 characters per row
    if (( (count+1) % 4 == 0 )); then
      echo ""
    fi

    ((count++))
  done
}

# Pagination loop for displaying 500 characters at a time
while true; do
  clear
  print_chars "$start_point"

  # Increment the start point by 500 for the next page
  start_point=$((start_point + 500))

  # Prompt for next page or exit
  read -p "Press Enter to see the next 500 characters or type 'q' to quit: " input
  [[ $input == "q" ]] && break
done


Example Output:

U+014C       Ō %14C         U+014D       ō %14D         U+014E       Ŏ %14E         U+014F       ŏ %14F         
U+0150       Ő %150         U+0151       ő %151         U+0152       Œ %152         U+0153       œ %153         
U+0154       Ŕ %154         U+0155       ŕ %155         U+0156       Ŗ %156         U+0157       ŗ %157         
U+0158       Ř %158         U+0159       ř %159         U+015A       Ś %15A         U+015B       ś %15B         
U+015C       Ŝ %15C         U+015D       ŝ %15D         U+015E       Ş %15E         U+015F       ş %15F         
U+0160       Š %160         U+0161       š %161         U+0162       Ţ %162         U+0163       ţ %163         
U+0164       Ť %164         U+0165       ť %165         U+0166       Ŧ %166         U+0167       ŧ %167         
U+0168       Ũ %168         U+0169       ũ %169         U+016A       Ū %16A         U+016B       ū %16B         
U+016C       Ŭ %16C         U+016D       ŭ %16D         U+016E       Ů %16E         U+016F       ů %16F         
U+0170       Ű %170         U+0171       ű %171         U+0172       Ų %172         U+0173       ų %173         
U+0174       Ŵ %174         U+0175       ŵ %175         U+0176       Ŷ %176         U+0177       ŷ %177         
U+0178       Ÿ %178         U+0179       Ź %179         U+017A       ź %17A         U+017B       Ż %17B         
U+017C       ż %17C         U+017D       Ž %17D         U+017E       ž %17E         U+017F       ſ %17F         
U+0180       ƀ %180         U+0181       Ɓ %181         U+0182       Ƃ %182         U+0183       ƃ %183         
U+0184       Ƅ %184         U+0185       ƅ %185         U+0186       Ɔ %186         U+0187       Ƈ %187         
U+0188       ƈ %188         U+0189       Ɖ %189         U+018A       Ɗ %18A         U+018B       Ƌ %18B         
U+018C       ƌ %18C         U+018D       ƍ %18D         U+018E       Ǝ %18E         U+018F       Ə %18F         
U+0190       Ɛ %190         U+0191       Ƒ %191         U+0192       ƒ %192         U+0193       Ɠ %193         
U+0194       Ɣ %194         U+0195       ƕ %195         U+0196       Ɩ %196         U+0197       Ɨ %197         
U+0198       Ƙ %198         U+0199       ƙ %199         U+019A       ƚ %19A         U+019B       ƛ %19B         
U+019C       Ɯ %19C         U+019D       Ɲ %19D         U+019E       ƞ %19E         U+019F       Ɵ %19F         
U+01A0       Ơ %1A0         U+01A1       ơ %1A1         U+01A2       Ƣ %1A2         U+01A3       ƣ %1A3         
U+01A4       Ƥ %1A4         U+01A5       ƥ %1A5         U+01A6       Ʀ %1A6         U+01A7       Ƨ %1A7         
U+01A8       ƨ %1A8         U+01A9       Ʃ %1A9         U+01AA       ƪ %1AA         U+01AB       ƫ %1AB         
U+01AC       Ƭ %1AC         U+01AD       ƭ %1AD         U+01AE       Ʈ %1AE         U+01AF       Ư %1AF         
U+01B0       ư %1B0         U+01B1       Ʊ %1B1         U+01B2       Ʋ %1B2         U+01B3       Ƴ %1B3         
U+01B4       ƴ %1B4         U+01B5       Ƶ %1B5         U+01B6       ƶ %1B6         U+01B7       Ʒ %1B7         
U+01B8       Ƹ %1B8         U+01B9       ƹ %1B9         U+01BA       ƺ %1BA         U+01BB       ƻ %1BB         
U+01BC       Ƽ %1BC         U+01BD       ƽ %1BD         U+01BE       ƾ %1BE         U+01BF       ƿ %1BF         
U+01C0       ǀ %1C0         U+01C1       ǁ %1C1         U+01C2       ǂ %1C2         U+01C3       ǃ %1C3         
U+01C4       Ǆ %1C4         U+01C5       ǅ %1C5         U+01C6       ǆ %1C6         U+01C7       Ǉ %1C7         
U+01C8       ǈ %1C8         U+01C9       ǉ %1C9         U+01CA       Ǌ %1CA         U+01CB       ǋ %1CB         
U+01CC       ǌ %1CC         U+01CD       Ǎ %1CD         U+01CE       ǎ %1CE         U+01CF       Ǐ %1CF         
U+01D0       ǐ %1D0         U+01D1       Ǒ %1D1         U+01D2       ǒ %1D2         U+01D3       Ǔ %1D3         
U+01D4       ǔ %1D4         U+01D5       Ǖ %1D5         U+01D6       ǖ %1D6         U+01D7       Ǘ %1D7         
U+01D8       ǘ %1D8         U+01D9       Ǚ %1D9         U+01DA       ǚ %1DA         U+01DB       Ǜ %1DB         
U+01DC       ǜ %1DC         U+01DD       ǝ %1DD         U+01DE       Ǟ %1DE         U+01DF       ǟ %1DF         
U+01E0       Ǡ %1E0         U+01E1       ǡ %1E1         U+01E2       Ǣ %1E2         U+01E3       ǣ %1E3         
U+01E4       Ǥ %1E4         U+01E5       ǥ %1E5         U+01E6       Ǧ %1E6         U+01E7       ǧ %1E7         
U+01E8       Ǩ %1E8         U+01E9       ǩ %1E9         U+01EA       Ǫ %1EA         U+01EB       ǫ %1EB         
U+01EC       Ǭ %1EC         U+01ED       ǭ %1ED         U+01EE       Ǯ %1EE         U+01EF       ǯ %1EF         
U+01F0       ǰ %1F0         U+01F1       Ǳ %1F1         U+01F2       ǲ %1F2         U+01F3       ǳ %1F3         
Press Enter to see the next 500 characters or type 'q' to quit: 

