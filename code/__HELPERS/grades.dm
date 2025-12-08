#define APPLY_GRADES(var, g1, g2, g3, g4, g5, g6) switch(grade) {\
		if(1) {##var = g1} \
		if(2) {##var = g2} \
		if(3) {##var = g3} \
		if(4) {##var = g4} \
		if(5) {##var = g5} \
		if(6) {##var = g6} }

#define APPLY_GRADES_ADD(var, g1, g2, g3, g4, g5, g6) switch(grade) {\
		if(1) {##var += g1} \
		if(2) {##var += g2} \
		if(3) {##var += g3} \
		if(4) {##var += g4} \
		if(5) {##var += g5} \
		if(6) {##var += g6} }

#define APPLY_GRADES_MUL(var, g1, g2, g3, g4, g5, g6) switch(grade) {\
		if(1) {##var *= g1} \
		if(2) {##var *= g2} \
		if(3) {##var *= g3} \
		if(4) {##var *= g4} \
		if(5) {##var *= g5} \
		if(6) {##var *= g6} }

#define APPLY_GRADES_RATING(g1, g2, g3, g4, g5, g6) switch(grade) {\
		if(1) {##g1} \
		if(2) {##g2} \
		if(3) {##g3} \
		if(4) {##g4} \
		if(5) {##g5} \
		if(6) {##g6} }

/proc/get_grade_name(grade)
	var/qualtity_text
	switch(grade)
		if(1)
			qualtity_text = "poorly-crafted"
		if(2)
			qualtity_text = "decently-crafted"
		if(3)
			qualtity_text = "finely-crafted"
		if(4)
			qualtity_text = "superior quality"
		if(5)
			qualtity_text = "exceptional"
		if(6)
			qualtity_text = "masterful"
		else
			qualtity_text = "masterful?"
	return qualtity_text

/proc/get_grade_color(grade)
	switch(grade)
		if(1)
			return "#C0C0C0"
		if(2)
			return "#964B00"
		if(3)
			return "#1976D2"
		if(4)
			return "#4CAF50"
		if(5)
			return "#BF40BF"
		if(6)
			return "#FFD700"
		else
			return "#ff0000"
