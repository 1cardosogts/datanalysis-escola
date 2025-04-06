CREATE TABLE schools (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC NOT NULL,
    school_id INT NOT NULL,
    FOREIGN KEY (school_id) REFERENCES schools(id)
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    enrolled_at DATE NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO schools (name) VALUES 
('Escola de Tecnologia'),
('Instituto de Dados');

INSERT INTO courses (name, price, school_id) VALUES
('Data Science Básico', 1000.00, 1),
('Data Analytics Avançado', 1500.00, 1),
('Introdução à Data Science', 1200.00, 2);

INSERT INTO students (name, enrolled_at, course_id) VALUES
('Ana Silva', '2025-03-01', 1),
('Bruno Souza', '2025-03-01', 1),
('Carlos Oliveira', '2025-03-02', 2),
('Daniela Santos', '2025-03-03', 3),
('Eduardo Lima', '2025-03-03', 3);

INSERT INTO students (name, enrolled_at, course_id) VALUES
('Fernanda Costa', '2025-03-04', 1),
('Gabriel Rocha', '2025-03-04', 2),
('Helena Martins', '2025-03-05', 1),
('Igor Dias', '2025-03-05', 2),
('Juliana Mendes', '2025-03-06', 1),
('Kauã Pereira', '2025-03-06', 2),
('Larissa Gomes', '2025-03-07', 1),
('Marcos Faria', '2025-03-07', 2),
('Natalia Silva', '2025-03-08', 1),
('Otávio Alves', '2025-03-08', 2),
('Paula Ribeiro', '2025-03-09', 1),
('Ricardo Nunes', '2025-03-09', 2),
('Sabrina Teixeira', '2025-03-10', 1),
('Tiago Correia', '2025-03-10', 2),
('Ursula Monteiro', '2025-03-11', 1),
('Vinicius Barros', '2025-03-11', 2),
('Wanda Lima', '2025-03-12', 1),
('Xavier Pinto', '2025-03-12', 2),
('Yasmin Figueiredo', '2025-03-13', 1),
('Zeca Albuquerque', '2025-03-13', 2),
('Adriano Fonseca', '2025-03-14', 1),
('Bianca Castro', '2025-03-14', 2),
('Caio Ramos', '2025-03-15', 1),
('Diana Guimarães', '2025-03-15', 2),
('Eduardo Moreira', '2025-03-16', 1);

INSERT INTO students (name, enrolled_at, course_id) VALUES
('Fabiana Almeida', '2025-03-16', 3),
('Gustavo Ribeiro', '2025-03-17', 3),
('Helena Oliveira', '2025-03-17', 3),
('Igor Martins', '2025-03-18', 3),
('Joana Dias', '2025-03-18', 3),
('Karol Souza', '2025-03-19', 3),
('Lucas Pereira', '2025-03-19', 3),
('Mariana Silva', '2025-03-20', 3),
('Natan Costa', '2025-03-20', 3),
('Olivia Santos', '2025-03-21', 3);

SELECT
    sch.name AS school_name,
    st.enrolled_at AS enrollment_date,
    COUNT(*) AS total_students,
    SUM(c.price) AS total_enrollment_value
FROM students st
JOIN courses c ON st.course_id = c.id
JOIN schools sch ON c.school_id = sch.id
WHERE LOWER(c.name) LIKE 'data%'
GROUP BY sch.name, st.enrolled_at
ORDER BY st.enrolled_at DESC;

WITH daily_data AS (
    SELECT
        sch.name AS school_name,
        st.enrolled_at AS enrollment_date,
        COUNT(*) AS total_students
    FROM students st
    JOIN courses c ON st.course_id = c.id
    JOIN schools sch ON c.school_id = sch.id
    WHERE LOWER(c.name) LIKE 'data%'
    GROUP BY sch.name, st.enrolled_at
)
SELECT
    school_name,
    enrollment_date,
    total_students,
    SUM(total_students) OVER (
        PARTITION BY school_name 
        ORDER BY enrollment_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_students,
    AVG(total_students) OVER (
        PARTITION BY school_name 
        ORDER BY enrollment_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7,
    AVG(total_students) OVER (
        PARTITION BY school_name 
        ORDER BY enrollment_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS moving_avg_30
FROM daily_data
ORDER BY school_name, enrollment_date;
