$definitions.typ()$

#import "typst-template/template/template-long.typ": post-content-container

$typst-template.typ()$

$for(header-includes)$
$header-includes$
$endfor$

$typst-show.typ()$

$for(include-before)$
$include-before$
$endfor$

$body$

#show: post-content-container

$notes.typ()$

$biblio.typ()$

$for(include-after)$
$include-after$
$endfor$
