# Orbital Cleanup

A space-themed debris collection game built with Flutter and Flame.

## Play Now

**[Play Orbital Cleanup Online](https://timely-dolphin-d25a8f.netlify.app/)**

## Game Description

Navigate your spacecraft through various orbital zones to clean up space debris. Collect green items to score points while carefully avoiding hazardous red asteroids that will end your mission instantly. Complete each level's target score before time runs out to advance!

## How to Play

- **Tap/Click** on the screen to move your spacecraft to that position
- **Collect** green debris to earn points
- **Avoid** red obstacles and hazards - collisions are fatal!
- **Complete** the target score before the timer runs out to advance to the next level

## Controls

- **Mobile**: Tap anywhere on the screen to move your spacecraft
- **Desktop**: Click with mouse to move your spacecraft
- **Game Menu**: Use the pause button in the top-right corner to access game options

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

## Credits

- **Music**: Space-themed background music to enhance the gameplay experience
- **Graphics**: Custom space assets and debris designs
- **Framework**: Built with Flutter and the Flame game engine

## License

This project is licensed under the MIT License - see the LICENSE file for details.
