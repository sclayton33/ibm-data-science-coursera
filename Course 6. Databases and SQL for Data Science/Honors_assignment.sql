select CR.CASE_NUMBER, CR.PRIMARY_TYPE, C.COMMUNITY_AREA_NAME
from CHICAGO_CRIME_DATA as CR
left outer join CENSUS_DATA as C on CR.COMMUNITY_AREA_NUMBER = C.COMMUNITY_AREA_NUMBER
where location_description like '%SCHOOL%';

create view school_view as
select
	NAME_OF_SCHOOL as School_Name,
	Safety_Icon as Safety_Rating,
	Family_Involvement_Icon as Family_Rating,
	Environment_Icon as Environment_Rating,
	Instruction_Icon as Instruction_Rating,
	Leaders_Icon as Leaders_Rating,
	Teachers_Icon as Teachers_Rating
from CHICAGO_PUBLIC_SCHOOLS;

select * from school_view;

select School_Name, Leaders_Rating from school_view;

--#SET TERMINATOR @
create procedure UPDATE_LEADERS_SCORE (
	IN in_School_ID INTEGER, IN in_Leaders_Score INTEGER)

LANGUAGE SQL
MODIFIES SQL DATA

BEGIN
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leaders_Score
	WHERE School_ID = in_School_ID;

	IF in_Leaders_Score > 0 AND in_Leaders_Score < 20 THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Very weak'
		WHERE in_School_ID = School_ID AND in_Leaders_Score = Leaders_Score;
		
	ELSEIF in_Leaders_Score < 40 THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Weak'
		WHERE in_School_ID = School_ID AND in_Leaders_Score = Leaders_Score;
		
	ELSEIF in_Leaders_Score < 60 THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Average'
		WHERE in_School_ID = School_ID AND in_Leaders_Score = Leaders_Score;
		
	ELSEIF in_Leaders_Score < 80 THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Strong'
		WHERE in_School_ID = School_ID AND in_Leaders_Score = Leaders_Score;
		
	ELSEIF in_Leaders_Score < 100 THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Very strong'
		WHERE in_School_ID = School_ID AND in_Leaders_Score = Leaders_Score;
		
	ELSE
		ROLLBACK WORK;
		
	END IF;
	
	COMMIT WORK;
		
END

@

