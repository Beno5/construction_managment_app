const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js', // Uključivanje Flowbite datoteka
  ],
  safelist: [
    // Dodajte sve potrebne klase ovdje
    'fixed', 'top-28', 'left-1/2', 'transform', '-translate-x-1/2',
    'z-50', 'transition-opacity', 'duration-500',
    'bg-green-100', 'text-green-700',
    'bg-red-100', 'text-red-700',
    'px-8', 'py-4', 'rounded-lg', 'text-2xl',
    'rounded-l-lg',
    'rounded-r-lg',
    'bg-gray-200',
    'bg-primary-500',
    'bg-primary-600',
    'bg-primary-700',
    'hover:bg-primary-700',
    'focus:ring-primary-300',
    'text-white',
    'w-64',
    'w-1/2',
    'grid-cols-4',
    'grid-cols-7',
    'h-6',
    'leading-6',
    'h-9',
    'leading-9',
    'shadow-lg',
    'bg-opacity-50',
    'dark:bg-opacity-80',
    'peer-checked:after:translate-x-full',
    'after:transition-all',
    // Dodajte Flowbite specifične klase
    'after:content-[""]',
    'after:absolute',
    'after:top-[2px]',
    'after:start-[2px]',
    'after:bg-white',
    'after:border-gray-300',
    'after:border',
    'after:rounded-full',
    'after:h-5',
    'after:w-5',
    'peer-checked:after:translate-x-full',
    'rtl:peer-checked:after:-translate-x-full',
    'peer-checked:after:border-white',
  ],
  darkMode: 'class', // Dark mode na temelju klase
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
          "900": "#1e3a8a",
          "950": "#172554", // Dodana boja 950
        },
      },
      fontFamily: {
        sans: [
          'Inter', 
          'ui-sans-serif', 
          'system-ui', 
          '-apple-system', 
          'Segoe UI', 
          'Roboto', 
          'Helvetica Neue', 
          'Arial', 
          'Noto Sans', 
          'sans-serif', 
          'Apple Color Emoji', 
          'Segoe UI Emoji', 
          'Segoe UI Symbol', 
          'Noto Color Emoji',
          ...defaultTheme.fontFamily.sans,
        ],
        body: [
          'Inter', 
          'ui-sans-serif', 
          'system-ui', 
          '-apple-system', 
          'Segoe UI', 
          'Roboto', 
          'Helvetica Neue', 
          'Arial', 
          'Noto Sans', 
          'sans-serif', 
          'Apple Color Emoji', 
          'Segoe UI Emoji', 
          'Segoe UI Symbol', 
          'Noto Color Emoji',
          ...defaultTheme.fontFamily.sans,
        ],
      },
      translate: {
        'full': '100%', // Dodano kako bi Tailwind prepoznao translate-x-full
      },
      transitionProperty: {
        'width': 'width', // Animacije širine
        'opacity': 'opacity', // Dodana animacija za opacity
      },
      textDecoration: ['active'], // Aktivni stilovi
      minWidth: {
        'kanban': '28rem', // Minimalna širina za kanban
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('flowbite/plugin'), // Flowbite plugin
  ],
};
