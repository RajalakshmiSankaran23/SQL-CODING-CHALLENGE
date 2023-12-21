create database VirtualGallery;
use VirtualGallery;

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100) );CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)); CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT ); CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)); INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'); INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography'); INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, 
ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 
'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 
'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\s powerful anti-war mural.', 
'guernica.jpg');INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) 
VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of 
modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art 
treasures.');INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2); ---1 
SELECT Artists.ArtistID, Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM
Artists
LEFT JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY
Artists.ArtistID, Artists.Name
ORDER BY
NumArtworks DESC;


---2

SELECT
Artworks.Title,
Artists.Name AS ArtistName,
Artworks.Year
FROM Artworks
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality IN ('Spanish', 'Dutch')
ORDER BY Artworks.Year ASC;

---3

SELECT
Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworksInPaintingCategory
FROM Artists
JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN
Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE
Categories.Name = 'Painting'
GROUP BY Artists.Name;

---4

SELECT
Artworks.Title AS ArtworkTitle,
Artists.Name AS ArtistName,
Categories.Name AS CategoryName
FROM
Artworks
JOIN
Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN
ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN
Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN
Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

---5

SELECT
Artists.ArtistID,
Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Artists
JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY
Artists.ArtistID, Artists.Name
HAVING
COUNT(Artworks.ArtworkID) > 2;

---6

SELECT
Artworks.Title AS ArtworkTitle
FROM
Artworks
JOIN
ExhibitionArtworks ea1 ON Artworks.ArtworkID = ea1.ArtworkID
JOIN
Exhibitions ex1 ON ea1.ExhibitionID = ex1.ExhibitionID
JOIN
ExhibitionArtworks ea2 ON Artworks.ArtworkID = ea2.ArtworkID
JOIN
Exhibitions ex2 ON ea2.ExhibitionID = ex2.ExhibitionID
WHERE ex1.Title = 'Modern Art Masterpieces' AND ex2.Title = 'Renaissance Art';

---7

SELECT Categories.Name AS CategoryName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Categories
LEFT JOIN
Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name;

---8

SELECT Artists.ArtistID,Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Artists
JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

---9

SELECT Artworks.Title AS ArtworkTitle, Artists.Name AS ArtistName, Artists.Nationality
FROM Artworks
JOIN
Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality = 'Spanish';

---10


SELECT Exhibitions.Title AS ExhibitionTitle, Exhibitions.StartDate, Exhibitions.EndDate
FROM Exhibitions
JOIN
ExhibitionArtworks ea1 ON Exhibitions.ExhibitionID = ea1.ExhibitionID
JOIN
Artworks aw1 ON ea1.ArtworkID = aw1.ArtworkID
JOIN
Artists a1 ON aw1.ArtistID = a1.ArtistID
JOIN
ExhibitionArtworks ea2 ON Exhibitions.ExhibitionID = ea2.ExhibitionID
JOIN
Artworks aw2 ON ea2.ArtworkID = aw2.ArtworkID
JOIN
Artists a2 ON aw2.ArtistID = a2.ArtistID
WHERE a1.Name = 'Vincent van Gogh' AND a2.Name = 'Leonardo da Vinci';

---11

SELECT Artworks.Title AS ArtworkTitle, Artists.Name AS ArtistName
FROM Artworks
JOIN
Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE
Artworks.ArtworkID NOT IN (SELECT ArtworkID FROM ExhibitionArtworks);

---12

SELECT Artists.ArtistID,Artists.Name AS ArtistName
FROM Artists
WHERE
NOT EXISTS (
SELECT Categories.CategoryID
FROM Categories
WHERE Categories.CategoryID NOT IN (
SELECT Artworks.CategoryID
FROM Artworks
WHERE Artworks.ArtistID = Artists.ArtistID)
);

---13

SELECT Categories.Name AS CategoryName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Categories
LEFT JOIN
Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name;

---14

SELECT Artists.ArtistID,Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Artists
JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 3;

---15

SELECT Categories.Name AS CategoryName,
AVG(Artworks.Year) AS AverageYear
FROM Categories
JOIN
Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

---16

SELECT Artworks.Title AS ArtworkTitle, Artists.Name AS ArtistName,Exhibitions.Title AS ExhibitionTitle
FROM Artworks
JOIN
ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN
Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN
Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

---17

SELECT Categories.Name AS CategoryName,
AVG(Artworks.Year) AS CategoryAverageYear,
(SELECT AVG(Year) FROM Artworks) AS OverallAverageYear
FROM Categories
JOIN
Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING AVG(Artworks.Year) > (SELECT AVG(Year) FROM Artworks);

---18

SELECT Artworks.Title AS ArtworkTitle, Artists.Name AS ArtistName
FROM Artworks
JOIN
Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artworks.ArtworkID NOT IN (SELECT ArtworkID FROM ExhibitionArtworks);

---19

SELECT DISTINCT A1.ArtistID, A1.Name AS ArtistName
FROM Artists A1
JOIN
Artworks AW1 ON A1.ArtistID = AW1.ArtistID
JOIN
Categories C1 ON AW1.CategoryID = C1.CategoryID
WHERE C1.CategoryID IN (
SELECT
C2.CategoryID
FROM Artworks AW2
JOIN
Categories C2 ON AW2.CategoryID = C2.CategoryID
WHERE AW2.Title = 'Mona Lisa'
)
AND A1.ArtistID <> (
SELECT A3.ArtistID
FROM Artists A3
JOIN Artworks AW3 ON A3.ArtistID = AW3.ArtistID
WHERE AW3.Title = 'Mona Lisa'
);

---20

SELECT Artists.Name AS ArtistName,
COUNT(Artworks.ArtworkID) AS NumArtworks
FROM Artists
LEFT JOIN
Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name;















