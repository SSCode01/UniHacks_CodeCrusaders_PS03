#!/bin/bash

# ChaosClub Backend Setup Script

echo "🎭 ChaosClub Backend Setup 🎭"
echo "================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python 3 found"
echo ""

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please update .env with your configuration"
fi

# Run migrations
echo "🗄️  Setting up database..."
python manage.py makemigrations
python manage.py migrate

# Create superuser prompt
echo ""
echo "👤 Create admin user?"
read -p "Would you like to create an admin user? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python manage.py createsuperuser
fi

# Create initial badges
echo ""
echo "🏆 Creating initial badges..."
python manage.py shell << EOF
from users.models import Badge

badges = [
    {'name': 'roast_king', 'description': 'Master of roasts', 'icon': '👑', 'points_required': 100},
    {'name': 'meme_master', 'description': 'Meme legend', 'icon': '😂', 'points_required': 150},
    {'name': 'capsule_creator', 'description': 'Time capsule pro', 'icon': '📦', 'points_required': 50},
    {'name': 'streak_7', 'description': '7 day streak', 'icon': '🔥', 'points_required': 0},
    {'name': 'streak_30', 'description': '30 day streak', 'icon': '🌟', 'points_required': 0},
    {'name': 'poll_master', 'description': 'Poll creation expert', 'icon': '📊', 'points_required': 75},
    {'name': 'chaos_coordinator', 'description': 'Master of chaos', 'icon': '🎭', 'points_required': 200},
    {'name': 'squad_leader', 'description': 'Group leader', 'icon': '👥', 'points_required': 50},
]

for badge_data in badges:
    Badge.objects.get_or_create(**badge_data)

print("✅ Badges created successfully")
exit()
EOF

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 To start the development server:"
echo "   python manage.py runserver"
echo ""
echo "📚 API Documentation:"
echo "   http://127.0.0.1:8000/swagger/"
echo "   http://127.0.0.1:8000/redoc/"
echo ""
echo "🔧 Admin Panel:"
echo "   http://127.0.0.1:8000/admin/"
echo ""
