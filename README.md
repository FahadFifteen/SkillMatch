# SkillMatch

A MySQL 8 database that compares a student's skills with real job requirements.

For every job, each required skill is classified as:
- **Qualified**: your level meets or exceeds the requirement
- **Needs Improvement**: you have the skill, but at a lower level
- **Missing**: you don't have the skill yet

The database then calculates a match percentage and ranks the best-fit jobs for each student.

## Database Design
7 tables: `Users`, `Categories`, `Skills`, `User_Skills`, `Jobs`, `Job_Skills`, `User_Job_Analysis`

Proficiency levels: Beginner (1), Intermediate (2), Advanced (3).

## How the match is calculated
- Qualified skill = 1 point
- Missing skill = 0 points
- Needs Improvement = user level ÷ required level
- Match % = total points ÷ number of required skills × 100

## Main Objects
- View: `Skill_Status_View`
- Procedures:
  - `Analyze_User_Job(user_id, job_id)`
  - `Match_Percentage_For(user_id, job_id)`
  - `Save_All_Analysis()`
  - `Best_Jobs_For_User(user_id)`

## How to Run
1. Install MySQL 8 and MySQL Workbench.
2. Open `SkillMatch.final.sql` in Workbench and run it.
3. Try it:
   ```sql
   USE SkillMatch;
   CALL Save_All_Analysis();
   CALL Best_Jobs_For_User(1);
   ```

Note: the script drops and recreates the `SkillMatch` database.

## Files
- `SkillMatch.final.sql`: full database script
- `SkillMatch_Final.ER.Diagram.pdf`: ER diagram
- `SkillMatch_Redesign.pdf`: project presentation

## Author
Fahad Murad
