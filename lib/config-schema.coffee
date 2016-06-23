module.exports =
	enabled:
		title: 'Enabled'
		type: 'boolean'
		default: true
		order: 1
	subreddits:
		title: 'SubReddit - Source'
		description: 'Enter the subreddits you would like to get images from (seperated by commas)'
		type: 'array'
		default: ["EarthPorn", "SpacePorn", "APodStream", "WindowShots", "Wallpapers", "ITookAPicture", "AlbumArtPorn", "MusicWallpapers", "ConcertPorn", "ExposurePorn", "SkyPorn", "FractalPorn", "ImaginaryTechnology", "BridgePorn"]
		order: 2
		items:
			type: 'string'
	refreshDuration:
		title: 'Refresh Duration'
		description: 'How often the background is refreshed (in seconds).'
		type: 'number'
		default: 900
		minimum: 60
		maximum: 360000
		order: 3
	nsfw:
		title: 'Hide NSFW Content'
		type: 'boolean'
		default: false
		order: 4
	advanced:
		type: 'object'
		properties:
			source:
				title: 'Advanced'
				type: 'string'
				default: 'Blur'
				enum: ['Blur', 'Grey', 'Dim']
				order: 5
			blur:
				title: 'Blur'
				type: 'number'
				default: 10
				minimum: 0
				maximum: 100
				order: 1
			grey:
				title: 'Grey'
				type: 'number'
				default: 0
				minimum: 0
				maximum: 100
				order: 2
			dim:
				title: 'Dim'
				type: 'number'
				default: 0
				minimum: 0
				maximum: 100
				order: 3
