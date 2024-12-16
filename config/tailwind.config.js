const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js', // Flowbite fajlovi
  ],
  safelist: [
    'w-64',
    'w-1/2',
    'rounded-l-lg',
    'rounded-r-lg',
    'bg-gray-200',
    'grid-cols-4',
    'grid-cols-7',
    'h-6',
    'leading-6',
    'h-9',
    'leading-9',
    'shadow-lg',
    'bg-opacity-50',
    'dark:bg-opacity-80'
  ],
  darkMode: "class", // Dark mode na osnovu klase
  theme: {
    extend: {
      colors: {
        primary: {
          "50": "#eff6ff",
          "100": "#dbeafe",
          "200": "#bfdbfe",
          "300": "#93c5fd",
          "400": "#60a5fa",
          "500": "#3b82f6",
          "600": "#2563eb",
          "700": "#1d4ed8",
          "800": "#1e40af",
          "900": "#1e3a8a"
        },
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        body: ['Inter', ...defaultTheme.fontFamily.sans],
        mono: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', 'monospace']
      },
      transitionProperty: {
        'width': 'width', // Animacije širine
        'opacity': 'opacity', // Dodata animacija za opacity
      },
      textDecoration: ['active'], // Aktivni stilovi
      minWidth: {
        'kanban': '28rem' // Minimalna širina za kanban
      },
    },
  },
  variants: {
    extend: {
      opacity: ['responsive', 'hover', 'focus', 'group-hover'], // Varijacije za opacity
      transitionProperty: ['responsive', 'motion-safe', 'motion-reduce'], // Varijacije za tranzicije
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('flowbite/plugin'), // Flowbite plugin
  ],
};
