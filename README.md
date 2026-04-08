# Crypto
Crypto is an iOS app built with SwiftUI for tracking the crypto market and managing a personal crypto portfolio.
The app fetches market data from CoinGecko, displays a list of coins, provides detailed analytics for each asset, and lets users manage holdings with local persistence.

https://github.com/user-attachments/assets/6f9cb646-27bb-4595-8397-f497f30191ab

https://github.com/user-attachments/assets/6129f75a-4d3c-4c4e-b6fc-eadc8fe566e9

## Features
- Browse cryptocurrencies with price, market cap, and 24h change
- Search and sort coins (by rank, price, portfolio)
- Open a detailed coin screen with stats and charts
- Manage portfolio holdings (add/update coin amounts)
- Cache coin images locally and store portfolio data in Core Data
- Use a settings screen with useful data-source links

## Tech Stack
- SwiftUI — UI layer
- MVVM — presentation architecture
- Combine — reactive pipelines and networking flow
- Core Data — portfolio storage
- Swift Charts — chart rendering on the detail screen
- URLSession — HTTP requests to the CoinGecko API

## Architecture

The app follows this flow:

**Views -> ViewModels -> Services -> (Network/API, CoreData, Local cache)**

- Home: coin list, search, sorting, and aggregated market/portfolio stats
- Detail: extended info for a selected coin, key metrics, and charts
- Services:
   - load coin list and global market data (CoinGecko)
   - load per-coin details
   - manage portfolio data in Core Data
   - download and cache coin images

## Data Source
- API: [CoinGecko](https://www.coingecko.com/)
- Main endpoints:
   - /coins/markets
   - /global
   - /coins/{id}

## Run Locally
- Open CryptoApp.xcodeproj in Xcode
- Select the CryptoApp scheme
- Run on simulator or device (Cmd + R)

## Supported devices
- iPhone
- iPad
