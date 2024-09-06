-- Ejercicio 1: Uso de Joins

-- Pregunta 1:
-- Escribe y ejecuta una consulta SQL para listar los nombres de las escuelas, nombres de las comunidades y la asistencia promedio 
-- para las comunidades con un índice de dificultad de 98.
SELECT P_SL.NAME_OF_SCHOOL, P_SL.COMMUNITY_AREA_NAME, P_SL.AVERAGE_STUDENT_ATTENDANCE
FROM chicago_public_schools AS P_SL
LEFT JOIN chicago_socioeconomic_data AS socio
ON P_SL.COMMUNITY_AREA_NAME = socio.COMMUNITY_AREA_NAME
WHERE socio.HARDSHIP_INDEX = 98;

-- Pregunta 2:
-- Escribe y ejecuta una consulta SQL para listar todos los delitos que ocurrieron en una escuela. Incluye el número de caso, tipo de delito 
-- y nombre de la comunidad.
SELECT ch_crime.CASE_NUMBER, ch_crime.PRIMARY_TYPE, socio.COMMUNITY_AREA_NAME
FROM chicago_crime AS ch_crime
LEFT JOIN chicago_socioeconomic_data AS socio
ON ch_crime.COMMUNITY_AREA_NUMBER = socio.COMMUNITY_AREA_NUMBER
WHERE ch_crime.LOCATION_DESCRIPTION LIKE '%SCHOOL%'
ORDER BY ch_crime.CASE_NUMBER, socio.COMMUNITY_AREA_NAME;

-- Ejercicio 2: Creación de una Vista

-- Pregunta 1:
-- Escribe y ejecuta una sentencia SQL para crear una vista que muestre columnas específicas con nuevos nombres.
CREATE VIEW Chicago_p_schools_v AS
SELECT NAME_OF_SCHOOL AS School_Name,
       Safety_Icon AS Safety_Rating,
       Family_Involvement_Icon AS Family_Rating,
       Environment_Icon AS Environment_Rating,
       Instruction_Icon AS Instruction_Rating,
       Leaders_Icon AS Leaders_Rating,
       Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools;

-- Para verificar la vista y devolver todas las columnas
SELECT * FROM Chicago_p_schools_v;

-- Para devolver solo el nombre de la escuela y la calificación de líderes
SELECT School_Name, Leaders_Rating FROM Chicago_p_schools_v;

-- Ejercicio 3: Creación de un Procedimiento Almacenado

-- Pregunta 1:
-- Escribe la estructura de una consulta para crear o reemplazar un procedimiento almacenado llamado `UPDATE_LEADERS_SCORE`.
DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_SCORE(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
    UPDATE chicago_public_schools
    SET Leaders_Score = in_Leader_Score
    WHERE School_ID = in_School_ID;
END $$
DELIMITER ;

-- Pregunta 2:
-- Dentro de tu procedimiento almacenado, escribe una sentencia SQL para actualizar el campo Leaders_Score.
-- Esto ya está incluido en el procedimiento anterior.

-- Pregunta 3:
-- Dentro de tu procedimiento almacenado, escribe una sentencia IF para actualizar el campo Leaders_Icon.
DELIMITER $$
CREATE PROCEDURE UPDATE_LEADERS_ICON(IN in_School_ID INT, IN in_Leader_Score INT)
BEGIN
    -- Manejo de excepciones
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Deshacer los cambios en caso de error
        RESIGNAL;  -- Propagar el error
    END;

    START TRANSACTION;  -- Iniciar una transacción

    -- Condicional para actualizar el campo Leaders_Icon según el puntaje
    IF in_Leader_Score >= 0 AND in_Leader_Score <= 19 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 39 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 59 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 79 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;
    ELSEIF in_Leader_Score <= 99 THEN
        UPDATE chicago_public_schools
        SET Leaders_Icon = 'Very strong'
        WHERE School_ID = in_School_ID;
    ELSE
        -- Señalar un error si el puntaje no está en el rango permitido
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor inválido para in_Leader_Score. El valor debe estar entre 0 y 99.';
    END IF;

    COMMIT;  -- Confirmar la transacción si todo está bien
END $$

-- Restablece el delimitador al valor predeterminado
DELIMITER ;

-- Prueba el procedimiento con datos válidos e inválidos:
-- CALL UPDATE_LEADERS_ICON(610185, 50); -- Puntaje válido
-- CALL UPDATE_LEADERS_ICON(610185, 101); -- Puntaje inválido

-- Ejercicio 4: Uso de Transacciones

-- Pregunta 1:
-- Actualiza la definición de tu procedimiento almacenado. Añade una cláusula ELSE genérica que haga rollback del trabajo actual si el puntaje no encaja en ninguna de las categorías anteriores.
-- Esto está incluido en el procedimiento almacenado `UPDATE_LEADERS_ICON` actualizado anteriormente.

-- Pregunta 2:
-- Actualiza la definición de tu procedimiento almacenado nuevamente. Añade una sentencia para confirmar la unidad de trabajo al final del procedimiento.
-- Esto también está incluido en el procedimiento almacenado `UPDATE_LEADERS_ICON` actualizado anteriormente.
