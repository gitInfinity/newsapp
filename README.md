# Flutter News App

A modern Flutter news application that fetches articles using NewsAPI and displays them in a clean, dynamic, and responsive UI.  
Built with BLoC state management, REST API integration, and optional AI-powered summarization (Gemini).

---

## Table of contents

- [Features](#features)  
- [Tech stack](#tech-stack)  
- [Project structure](#project-structure)  
- [Installation](#installation)  
- [Configuration](#configuration)  
- [Running the app](#running-the-app)  
- [How it works](#how-it-works)  
- [Development tips](#development-tips)  
- [Roadmap](#roadmap)  
- [Contributing](#contributing)  
- [License](#license)  
- [Acknowledgements](#acknowledgements)

---

## Features

- Responsive and adaptive UI (GridView article layout for larger screens).  
- BLoC architecture (Events → Bloc → States → UI) for separation of concerns.  
- HTTP integration using `http` package to fetch live news from NewsAPI.  
- Robust error handling (API errors, rate limits, parsing issues).  
- Welcome / initial state that shows a friendly prompt before the first search.  
- Article detail screen with thumbnail, description, and “Summarise by Gemini” button (Gemini integration is optional).  
- Defensive UI: fallbacks for missing images and missing article fields.  
- Simple repository layer (`NewsRepo`) to separate networking from BLoC logic.

---

## Tech stack

- Flutter  
- Dart  
- flutter_bloc (BLoC pattern)  
- http (REST requests)  
- intl (date formatting)  
- flutter_gemini (optional — summarization; add only if you have access)  
- cached_network_image (recommended for image caching)  
- url_launcher (open article links)

---

## Installation

1. Clone the repository:
   ```bash
  - git clone https://github.com/your-username/newsapp.git
  - cd newsapp

