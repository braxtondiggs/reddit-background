# reddit-background [![Code Climate](https://codeclimate.com/github/braxtondiggs/reddit-background/badges/gpa.svg)](https://codeclimate.com/github/braxtondiggs/reddit-background) [![Issue Count](https://codeclimate.com/github/braxtondiggs/reddit-background/badges/issue_count.svg)](https://codeclimate.com/github/braxtondiggs/reddit-background)

Change your [Atom](https://atom.io/) background to display any picture from multiple subreddits from [Reddit](https://reddit.com/).

## Features
- Show popular images from a combination of different subreddits
- Background image automatically changes with a customizable refresh rate
- Customizable filter can be applied to the background image (Blur, Contrast, Greyscale)

### Options
```javascript
{
    pause: {
        title: 'Paused',
        type: 'boolean',
        "default": false,
        order: 1
    },
    subreddits: {
        title: 'SubReddit - Source',
        description: 'Enter the subreddits you would like to get images from (seperated by commas)',
        type: 'array',
        "default": ["EarthPorn", "SpacePorn", "APodStream", "WindowShots", "Wallpapers", "ITookAPicture", "AlbumArtPorn", "MusicWallpapers", "ConcertPorn", "ExposurePorn", "SkyPorn", "FractalPorn", "ImaginaryTechnology", "BridgePorn"],
        order: 2,
        items: {
            type: 'string'
        }
    },
    refreshDuration: {
        title: 'Refresh Duration',
        description: 'How often the background is refreshed (in seconds).',
        type: 'number',
        "default": 900,
        minimum: 60,
        maximum: 360000,
        order: 3
    },
    nsfw: {
        title: 'Hide NSFW Content',
        type: 'boolean',
        "default": false,
        order: 4
    },
    blur: {
        title: 'Blur',
        type: 'number',
        "default": 5,
        minimum: 0,
        maximum: 100,
        order: 5
    },
    grey: {
        title: 'Grey',
        type: 'number',
        "default": 0,
        minimum: 0,
        maximum: 100,
        order: 6
    },
    contrast: {
        title: 'Contrast',
        type: 'number',
        "default": 100,
        minimum: 0,
        maximum: 100,
        order: 7
    }
}
```

## License
Copyright (c) 2016 . Licensed under the MIT license.
