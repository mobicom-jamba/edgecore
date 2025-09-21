# Expert Content Distribution Strategy

## 🎯 **User Goals & Screen Mapping**

### **Dashboard Screen (Overview & Quick Actions)**
**Purpose**: Quick status check and immediate actions
**User Goals**: "How did I sleep?" and "What can I do now?"

**KEEP ON DASHBOARD:**
- ✅ Greeting Header (contextual, personal)
- ✅ Last Night's Sleep Summary (main metric: duration + quality score)
- ✅ Sleep Now FAB (evening action)
- ✅ Today's Focus (actionable daily goal)
- ✅ Quick Log Actions (caffeine, mood, etc.)

**REMOVE FROM DASHBOARD:**
- ❌ Detailed Sleep Patterns Chart → Analytics Screen
- ❌ Sleep Stages Breakdown → Analytics Screen  
- ❌ Smart Insights → Analytics Screen
- ❌ Sleep Wave Visualization → Sleep Detail Screen

---

### **Analytics Screen (Data & Insights)**
**Purpose**: Detailed analysis and trends
**User Goals**: "How am I trending?" and "What patterns do I have?"

**MOVE TO ANALYTICS:**
- ✅ Sleep Patterns Chart (with period selection)
- ✅ Sleep Stages Breakdown (enhanced)
- ✅ Smart Insights (expanded with more insights)
- ✅ Weekly/Monthly trends
- ✅ Sleep debt tracking
- ✅ Comparative analysis
- ✅ Sleep efficiency metrics

---

### **Sleep Detail Screen (NEW - Individual Session)**
**Purpose**: Deep dive into specific sleep session
**User Goals**: "Tell me everything about last night's sleep"

**NEW SCREEN CONTENT:**
- ✅ Detailed Sleep Wave (hypnogram)
- ✅ Sleep stages timeline
- ✅ Environmental factors
- ✅ Heart rate data
- ✅ Movement tracking
- ✅ Sleep disruptions
- ✅ Recovery metrics

---

### **Soundscapes Screen (Sleep Environment)**
**Purpose**: Sleep preparation and environment
**User Goals**: "Help me fall asleep" and "Create good sleep environment"

**ENHANCE SOUNDSCAPES:**
- ✅ Current soundscapes functionality
- ✅ Sleep stories
- ✅ Bedtime routine builder
- ✅ Smart alarm settings
- ✅ Environment optimization tips

---

## 🏗️ **Information Architecture Principles**

### **Progressive Disclosure**
1. **Dashboard**: High-level overview (5-second scan)
2. **Analytics**: Detailed trends (2-minute analysis)  
3. **Sleep Detail**: Complete session data (deep dive)

### **Task-Oriented Design**
- **Morning**: Dashboard for "How did I sleep?"
- **Day**: Analytics for "How am I doing overall?"
- **Evening**: Soundscapes for "Help me sleep better"

### **Cognitive Load Reduction**
- **Dashboard**: Maximum 3 key metrics visible at once
- **Analytics**: Organized in logical sections with clear headers
- **Detail**: Comprehensive but well-structured data

---

## 📱 **Screen Transition Flow**

```
Dashboard
├── Tap Sleep Summary → Sleep Detail Screen
├── Tap "View All" Insights → Analytics Screen  
├── Sleep Now FAB → Sleep Session
└── Quick Actions → Log Entry

Analytics
├── Tap Chart → Detailed Analytics
├── Tap Insight → Insight Detail
└── Back → Dashboard

Sleep Detail
├── Compare → Analytics Screen
├── Share → Export Options
└── Back → Dashboard
```

---

## 🎨 **Visual Hierarchy Strategy**

### **Dashboard Priorities**
1. **Primary**: Last night's sleep (largest, most prominent)
2. **Secondary**: Today's focus and quick actions
3. **Tertiary**: Contextual greeting and notifications

### **Analytics Priorities**
1. **Primary**: Trend charts and key metrics
2. **Secondary**: Insights and recommendations
3. **Tertiary**: Detailed breakdowns and comparisons

### **Content Density Guidelines**
- **Dashboard**: Minimal, scannable (3-5 key elements)
- **Analytics**: Moderate, organized (6-8 sections)
- **Detail**: Dense but structured (comprehensive data)
