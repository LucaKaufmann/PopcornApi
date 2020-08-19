# Popcorn API

| API route  | Description  |
|---|---|
| /api/user/login  | Accepts email and password, returns token |
| /api/content


# API routes

## Login
**POST** /api/user/login 

Headers: none

Parameters:
email
password

Returns: 
User token

## Content


Headers: 
Authorization - Bearer + token


---

**GET** /api/content/topics

Parameters: None

Returns: List of topics

---

**GET** /api/content/subtopics

Parameters: None

Returns: List of subtopics

---

**GET** /api/content/videos

Parameters: None

Returns: List of videos

---


**POST** /api/content/topics

Parameters: title

Returns: None

---

**POST** /api/content/subtopics

Parameters: None

Returns: List of subtopics

---

**POST** /api/content/videos

Parameters: None

Returns: List of videos