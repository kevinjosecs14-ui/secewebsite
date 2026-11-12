/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        sece: {
          navy: '#173B63',        // Primary Navy
          deepNavy: '#102A43',    // Deep Navy
          primary: '#2F6DB2',     // Blue
          primaryHover: '#245994',
          bgLight: '#F5F8FC',     // Light Background
          border: '#DCE5EF',      // Border
          gold: '#F4C542',        // Gold Accent
          goldHover: '#E0B030',
          lightBlue: '#EAF2FA',
          slate: '#334E68',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        display: ['Outfit', 'Inter', 'sans-serif'],
      },
      boxShadow: {
        'subtle': '0 1px 3px 0 rgba(16, 42, 67, 0.05), 0 1px 2px 0 rgba(16, 42, 67, 0.03)',
        'card': '0 4px 12px 0 rgba(16, 42, 67, 0.06)',
        'card-hover': '0 10px 24px -3px rgba(16, 42, 67, 0.12)',
      }
    },
  },
  plugins: [],
}
