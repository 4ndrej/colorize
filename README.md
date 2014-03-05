# colorize

Log colorize pipe filter.

This repo is resurrection of Daniel Flinkmann's colorize.pl from http://www.Flinkmann.de (site is not working anymore). Latest colorizer page snapshot is available at wonderful [archive.org](https://web.archive.org/web/20070515144714/http://www.flinkmann.de/colorize-pl.71.0.html) but without colorize-0.3a.tgz file.

## How to Install

### Single Users
Just copy the `colorize.pl` into your own `~/bin/` binary directory.

### Administrators
For Administrators who want to offer this tool systemwide, please copy `colorize.pl` to `/usr/local/bin` or any other systemwide available directory.

## How to use

Use any kind of `<stdin>` text stream with a pipe.

```
ls -lF | colorize.pl [options]
```

colorize.pl will print out every line from `<stdin>` to `<stdout>`.  Rows with matching strings will be colorized with your choice of color.

### colorizing whole rows

Just start colorize string with **minus** character.

Standard Options format:
```
-<style><foreground><background>:<searchstring>
```
Quick colorisation Options format:
```
-:<searchstring>
```

### colorizing single words

Just start colorize string with **plus** character:

Standard options format: `+<style><foreground><background>:<searchstring>`

Quick colorisatoin options format: `+:<searchstring>`

Parameters:

`<style>`

n = normal, l = light, u = underscore, i = inverted, b = blinking

`<foreground color>`

0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = purple, 6 = cyan, 7 = white

`<background color>`

0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = purple, 6 = cyan, 7 = white, 8 = no background

`<searchstring>`

string (or regular expression)

## Examples

`cat output-logfile.txt |colorize.pl -u17:error -n37:warning -b10:funny`

will colorize lines with the word:
- "error" underscored in red front color and white background
- "warning" in green front color and white background
- "funny" blinking in red front color with black background

`cat output-logfile.txt |colorize.pl -:error -:warning -:funny`

will colorize lines with the word:
- "error" in the first preset color set
- "warning" in the second preset color set
- "funny" in the third preset color set

`cat output-logfile.txt |colorize.pl +:warning`

will colorize just the word "warning" with the first preset color set. 

`cat output-logfile.txt |colorize. pl +u18:error`

will colorize just the word "error" red with no background and underscore it.

`cat output-logfile.txt |colorize.pl +:'\t' +:' '`

will colorize all TABs (regular expression `'\t'`) and all Spaces `' '` into different colors. (Great for space/tab sensitive configs like sendmail etc.)

`cat output-logfile.txt |colorize.pl +:'\d'`

will colorize all digits
