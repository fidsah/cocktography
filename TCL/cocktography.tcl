#cocktography v1.0.0 by Vin
package provide cocktography

namespace eval ::cocktography {
    namespace export enchode dechode
}

set dick { Enchode { e 8=D o 8==D d 8===D D 8====D E 8=D~ i 8==D~ l 8===D~ L 8====D~ w 8=D~~ W 8==D~~ g 8===D~~ G 8====D~~ c 8=D~~~ C 8==D~~~ f 8===D~~~ F 8====D~~~ u 8=D~~~~ U 8==D~~~~ m 8===D~~~~ M 8====D~~~~ t 8wD a 8w=D H 8w==D y 8w===D T 8wD~ n 8w=D~ Y 8w==D~ p 8w===D~ P 8wD~~ b 8w=D~~ B 8w==D~~ � 8w===D~~ h 8wD~~~ 1 8w=D~~~ ! 8w==D~~~ 2 8w===D~~~ @ 8wD~~~~ 3 8w=D~~~~ # 8w==D~~~~ 4 8w===D~~~~ A 8=wD $ 8=w=D 5 8=w==D % 8=wD~ 6 8=w=D~ ^ 8=w==D~ 7 8=wD~~ & 8=w=D~~ 8 8=w==D~~ * 8=wD~~~ 9 8=w=D~~~ ( 8=w==D~~~ 0 8=wD~~~~ ) 8=w=D~~~~ - 8=w==D~~~~ R 8==wD _ 8==w=D + 8==wD~ = 8==w=D~ , 8==wD~~ < 8==w=D~~ . 8==wD~~~ > 8==w=D~~~ / 8==wD~~~~ ? 8==w=D~~~~ ; 8===wD : 8===wD~ \" 8===wD~~ ' 8===wD~~~ \[ 8===wD~~~~ O 8m=D \{ 8m==D \] 8m===D I 8mD~ N 8m=D~ r 8m==D~ v 8m===D~ V 8mD~~ k 8m=D~~ K 8m==D~~ j 8m===D~~ J 8mD~~~ x 8m=D~~~ X 8m==D~~~ q 8m===D~~~ Q 8mD~~~~ z 8m=D~~~~ Z 8m==D~~~~ ` 8m===D~~~~ s 8=mD S 8=m=D \} 8=m==D \\ 8=mD~ | 8=m=D~ ~ 8=m==D~ start 8=wm=D stop 8=mw=D cont 8=ww=D mark 8wmD } Dechode { 8=D e 8==D o 8===D d 8====D D 8=D~ E 8==D~ i 8===D~ l 8====D~ L 8=D~~ w 8==D~~ W 8===D~~ g 8====D~~ G 8=D~~~ c 8==D~~~ C 8===D~~~ f 8====D~~~ F 8=D~~~~ u 8==D~~~~ U 8===D~~~~ m 8====D~~~~ M 8wD t 8w=D a 8w==D H 8w===D y 8wD~ T 8w=D~ n 8w==D~ Y 8w===D~ p 8wD~~ P 8w=D~~ b 8w==D~~ B 8w===D~~ � 8wD~~~ h 8w=D~~~ 1 8w==D~~~ ! 8w===D~~~ 2 8wD~~~~ @ 8w=D~~~~ 3 8w==D~~~~ # 8w===D~~~~ 4 8=wD A 8=w=D $ 8=w==D 5 8=wD~ % 8=w=D~ 6 8=w==D~ ^ 8=wD~~ 7 8=w=D~~ & 8=w==D~~ 8 8=wD~~~ * 8=w=D~~~ 9 8=w==D~~~ ( 8=wD~~~~ 0 8=w=D~~~~ ) 8=w==D~~~~ - 8==wD R 8==w=D _ 8==wD~ + 8==w=D~ = 8==wD~~ , 8==w=D~~ < 8==wD~~~ . 8==w=D~~~ > 8==wD~~~~ / 8==w=D~~~~ ? 8===wD ; 8===wD~ : 8===wD~~ \" 8===wD~~~ ' 8===wD~~~~ \[ 8m=D O 8m==D \{ 8m===D \] 8mD~ I 8m=D~ N 8m==D~ r 8m===D~ v 8mD~~ V 8m=D~~ k 8m==D~~ K 8m===D~~ j 8mD~~~ J 8m=D~~~ x 8m==D~~~ X 8m===D~~~ q 8mD~~~~ Q 8m=D~~~~ z 8m==D~~~~ Z 8m===D~~~~ ` 8=mD s 8=m=D S 8=m==D \} 8=mD~ \\ 8=m=D~ | 8=m==D~ ~ } }

proc ::cocktography::enchode {message} {
	global dick
	set newstring [dict get $dick Enchode start]
	foreach c [split [binary encode base64 [binary encode base64 $message]] {}] {
		append newstring " " [dict get $dick Enchode $c]
		if {[string length $newstring] > 340} {
			append newstring " " [dict get $dick Enchode cont]
			lappend multidicks $newstring
			set newstring [dict get $dick Enchode mark]
		}
	}
	append newstring " " [dict get $dick Enchode stop]
	lappend multidicks $newstring
	return $multidicks
}

proc ::cocktography::dechode {message} {
	global dick
	foreach c [regexp -all -inline {\S+} $message ] {
		if {$c ni "[dict get $dick Enchode start] [dict get $dick Enchode stop] [dict get $dick Enchode mark] [dict get $dick Enchode cont]"} {
			lappend newstring [dict get $dick Dechode $c]
		}
	}
	return [binary decode base64 [binary decode base64 $newstring]]
}