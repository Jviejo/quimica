#!/bin/bash

# Script para subir el proyecto a GitHub
# Proyecto: MSM Rincón - Recursos de Química

echo "🚀 Iniciando despliegue del proyecto a GitHub..."
echo "📁 Directorio actual: $(pwd)"
echo ""

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    echo "❌ Error: Git no está instalado. Por favor instala Git primero."
    exit 1
fi

# Verificar si estamos en un repositorio Git
if [ ! -d ".git" ]; then
    echo "📦 Inicializando repositorio Git..."
    git init
    echo "✅ Repositorio Git inicializado"
else
    echo "✅ Repositorio Git ya existe"
fi

# Crear .gitignore si no existe
if [ ! -f ".gitignore" ]; then
    echo "📝 Creando archivo .gitignore..."
    cat > .gitignore << EOF
# Archivos del sistema
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Archivos temporales
*.tmp
*.temp
*~

# Logs
*.log

# Archivos de configuración local
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Dependencias (si las hay en el futuro)
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.idea/
*.swp
*.swo

# Archivos de respaldo
*.bak
*.backup
EOF
    echo "✅ Archivo .gitignore creado"
else
    echo "✅ Archivo .gitignore ya existe"
fi

# Crear README.md si no existe
if [ ! -f "README.md" ]; then
    echo "📖 Creando archivo README.md..."
    cat > README.md << 'EOF'
# 🧪 Química - MSM Rincón

Colección de recursos educativos interactivos para el aprendizaje de química.

## 📚 Contenido

### Cuestionarios Interactivos
- **Aislamiento del Níquel**: Cuestionario sobre el proceso de separación del níquel del alambre nicromo

## 🚀 Cómo usar

1. Clona este repositorio
2. Abre `index.html` en tu navegador web
3. Navega por los diferentes recursos educativos disponibles

## 📁 Estructura del proyecto

```
quimica/
├── index.html          # Página principal con índice
├── niquel.html         # Cuestionario sobre aislamiento del níquel
├── README.md           # Este archivo
└── .gitignore          # Archivos a ignorar por Git
```

## 🎯 Objetivos

Este proyecto tiene como objetivo proporcionar recursos educativos interactivos y modernos para facilitar el aprendizaje de conceptos químicos complejos.

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo LICENSE para más detalles.

## 👨‍🔬 Autor

MSM Rincón - Recursos educativos de química

---
*Última actualización: $(date '+%Y-%m-%d')*
EOF
    echo "✅ Archivo README.md creado"
else
    echo "✅ Archivo README.md ya existe"
fi

# Agregar todos los archivos al staging
echo "📋 Agregando archivos al staging..."
git add .

# Hacer commit inicial
echo "💾 Haciendo commit inicial..."
git commit -m "🎉 Commit inicial: Recursos educativos de química

- Cuestionario interactivo sobre aislamiento del níquel
- Página índice con navegación moderna
- Diseño responsivo y accesible
- Recursos educativos para estudiantes de química"

echo "✅ Commit realizado"

# Verificar si el repositorio remoto ya existe
if git remote get-url origin &> /dev/null; then
    echo "✅ Repositorio remoto ya configurado"
    echo "🔗 URL actual: $(git remote get-url origin)"
else
    echo "⚠️  No hay repositorio remoto configurado"
    echo "📝 Para configurar el repositorio remoto, ejecuta:"
    echo "   git remote add origin https://github.com/TU_USUARIO/quimica.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
    echo "🔧 O si prefieres usar SSH:"
    echo "   git remote add origin git@github.com:TU_USUARIO/quimica.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
fi

echo ""
echo "🎯 Pasos siguientes:"
echo "1. Ve a https://github.com y crea un nuevo repositorio llamado 'quimica'"
echo "2. Copia la URL del repositorio (HTTPS o SSH)"
echo "3. Ejecuta los siguientes comandos:"
echo ""
echo "   git remote add origin [URL_DE_TU_REPOSITORIO]"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "✨ ¡Tu proyecto estará disponible en GitHub!"
echo ""
echo "📊 Resumen de archivos preparados:"
git status --porcelain | wc -l | xargs echo "Archivos listos para subir:"
echo "📁 Archivos principales:"
ls -la *.html *.md 2>/dev/null || echo "No se encontraron archivos HTML o MD"
