#!/bin/bash

# Script para subir el proyecto a GitHub usando GitHub CLI
# Proyecto: MSM Rincón - Recursos de Química

echo "🚀 Iniciando despliegue del proyecto a GitHub..."
echo "📁 Directorio actual: $(pwd)"
echo ""

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    echo "❌ Error: Git no está instalado. Por favor instala Git primero."
    exit 1
fi

# Verificar si GitHub CLI está instalado
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) no está instalado."
    echo "📦 Instala GitHub CLI desde: https://cli.github.com/"
    echo "   macOS: brew install gh"
    echo "   Linux: apt install gh (o según tu distribución)"
    echo "   Windows: winget install GitHub.cli"
    exit 1
fi

# Verificar si el usuario está autenticado en GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "🔐 No estás autenticado en GitHub CLI."
    echo "🔑 Ejecuta: gh auth login"
    echo "   Selecciona GitHub.com y sigue las instrucciones"
    exit 1
fi

echo "✅ GitHub CLI está instalado y autenticado"

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

# Crear repositorio en GitHub usando GitHub CLI
echo "🌐 Creando repositorio en GitHub..."
REPO_NAME="quimica"
REPO_DESCRIPTION="Colección de recursos educativos interactivos para el aprendizaje de química"

# Verificar si el repositorio ya existe
if gh repo view "$REPO_NAME" &> /dev/null; then
    echo "⚠️  El repositorio '$REPO_NAME' ya existe en GitHub"
    echo "🔗 URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
else
    echo "📝 Creando repositorio '$REPO_NAME' en GitHub..."
    gh repo create "$REPO_NAME" \
        --public \
        --description "$REPO_DESCRIPTION" \
        --clone=false \
        --push=false
    
    if [ $? -eq 0 ]; then
        echo "✅ Repositorio creado exitosamente en GitHub"
        echo "🔗 URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
    else
        echo "❌ Error al crear el repositorio en GitHub"
        exit 1
    fi
fi

# Configurar el repositorio remoto
echo "🔗 Configurando repositorio remoto..."
USERNAME=$(gh api user --jq .login)
git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git" 2>/dev/null || {
    echo "⚠️  El repositorio remoto ya existe, actualizando URL..."
    git remote set-url origin "https://github.com/$USERNAME/$REPO_NAME.git"
}

# Cambiar a rama main
echo "🌿 Configurando rama main..."
git branch -M main

# Subir el código a GitHub
echo "📤 Subiendo código a GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡Proyecto desplegado exitosamente!"
    echo "🔗 URL del repositorio: https://github.com/$USERNAME/$REPO_NAME"
    echo "🌐 GitHub Pages (si está habilitado): https://$USERNAME.github.io/$REPO_NAME"
    echo ""
    echo "💡 Para habilitar GitHub Pages:"
    echo "   1. Ve a Settings > Pages en tu repositorio"
    echo "   2. Selecciona 'Deploy from a branch'"
    echo "   3. Elige 'main' branch y '/ (root)'"
    echo "   4. Guarda los cambios"
else
    echo "❌ Error al subir el código a GitHub"
    exit 1
fi
echo ""
echo "📊 Resumen de archivos preparados:"
git status --porcelain | wc -l | xargs echo "Archivos listos para subir:"
echo "📁 Archivos principales:"
ls -la *.html *.md 2>/dev/null || echo "No se encontraron archivos HTML o MD"
