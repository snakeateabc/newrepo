# Orbital Cleanup

A space-themed debris collection game built with Flutter and Flame.

![Game Screenshot](screenshots/gameplay.png)

## Game Description

Navigate your spacecraft through various orbital zones to clean up space debris. Collect green items to score points while carefully avoiding hazardous red asteroids that will end your mission instantly. Complete each level's target score before time runs out to advance!

## How to Play

- **Tap/Click** on the screen to move your spacecraft to that position
- **Collect** green debris to earn points
- **Avoid** red obstacles and hazards - collisions are fatal!
- **Complete** the target score before the timer runs out to advance to the next level

## Deployment to Vercel

This game can be easily deployed to Vercel for web hosting with the following steps:

1. Push your code to a GitHub repository
2. Log in to [Vercel](https://vercel.com)
3. Click "New Project" and select your GitHub repository
4. Keep the default build settings (the vercel.json file handles configuration)
5. Click "Deploy"

Vercel will automatically build and deploy your Flutter web app.

### Manual Deployment

If you prefer to deploy manually:

```bash
# Install Vercel CLI
npm install -g vercel

# Build the Flutter web app
flutter build web --release

# Deploy to Vercel
vercel
```

## Development

To run the project locally:

```bash
# Get dependencies
flutter pub get

# Run in debug mode
flutter run -d chrome
```

### Project Structure

- `lib/components` - Reusable UI components
- `lib/constants` - Game constants and styling
- `lib/game` - Core game mechanics and Flame implementation 
- `lib/models` - Game object models
- `lib/screens` - Game screens and UI
- `lib/utils` - Utility classes and helpers

## Responsive Design

The game adapts to different screen sizes:
- **Mobile**: Vertical orientation with controls optimized for touch
- **Desktop**: Horizontal orientation with larger play area and more elements

## Customization

You can customize game difficulty by modifying the constants in `lib/utils/constants.dart`.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
