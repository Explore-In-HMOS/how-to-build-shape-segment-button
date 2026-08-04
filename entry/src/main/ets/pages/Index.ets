import { EllipseShape, ExpandedMenuOptions, ExpandMode, PathShape, RectShape } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State selectedMode: number = 0;
  @State intensity: number = 1;
  @State settingsOpen: boolean = false;
  @State targetMinutes: number = 32;
  @State statusText: string = 'Ready on wearable';

  private get intensityLabel(): string {
    switch (this.intensity) {
      case 0:
        return 'Easy';
      case 2:
        return 'Hard';
      default:
        return 'Base';
    }
  }

  private get expandMode(): ExpandMode {
    return this.settingsOpen ? ExpandMode.EXPAND : ExpandMode.NOT_EXPAND;
  }

  private modeLabel(): string {
    switch (this.selectedMode) {
      case 1:
        return 'Walk';
      case 2:
        return 'Cycle';
      default:
        return 'Run';
    }
  }

  private modePace(): string {
    switch (this.selectedMode) {
      case 1:
        return '9:45/km';
      case 2:
        return '22 km/h';
      default:
        return '5:20/km';
    }
  }

  private modeAccent(): ResourceColor {
    switch (this.selectedMode) {
      case 1:
        return '#FCA5A5';
      case 2:
        return '#93C5FD';
      default:
        return '#6EE7B7';
    }
  }

  private modeDistance(): string {
    switch (this.selectedMode) {
      case 1:
        return '2.1 km';
      case 2:
        return '12 km';
      default:
        return '4.8 km';
    }
  }

  private createExpandedMenuOptions(): ExpandedMenuOptions[] {
    return [
      {
        content: 'Refresh target',
        action: () => {
          this.targetMinutes = this.targetMinutes >= 60 ? 24 : this.targetMinutes + 4;
          this.statusText = `Target ${this.targetMinutes} min`;
        }
      },
      {
        content: 'Toggle settings',
        action: () => {
          this.settingsOpen = !this.settingsOpen;
          this.statusText = this.settingsOpen ? 'Settings expanded' : 'Settings folded';
        }
      }
    ];
  }

  private runMenuAction(index: number): void {
    const option = this.createExpandedMenuOptions()[index];
    if (option.action) {
      option.action();
    }
  }

  private inspectExpandMode(): void {
    const settingsNode = this.getUIContext().getFrameNodeById('settingsPanel');
    if (!settingsNode) {
      this.statusText = 'settingsPanel not mounted';
      return;
    }
    const child = settingsNode.getChild(0, this.expandMode);
    const modeLabel = this.expandMode === ExpandMode.EXPAND ? 'EXPAND' : 'NOT_EXPAND';
    this.statusText = child ? `ExpandMode.${modeLabel} child ok` : `ExpandMode.${modeLabel} empty`;
  }

  @Builder
  ModePill(label: string, index: number): void {
    Text(label)
      .fontSize(10)
      .fontWeight(this.selectedMode === index ? FontWeight.Bold : FontWeight.Medium)
      .fontColor(this.selectedMode === index ? '#07111E' : '#D1D5DB')
      .textAlign(TextAlign.Center)
      .layoutWeight(1)
      .height(30)
      .backgroundColor(this.selectedMode === index ? this.modeAccent() : '#1F2937')
      .borderRadius(15)
      .onClick(() => {
        this.selectedMode = index;
        this.statusText = `${label} selected`;
      })
  }

  @Builder
  IntensityPill(label: string, index: number): void {
    Text(label)
      .fontSize(9)
      .fontColor(this.intensity === index ? '#07111E' : '#D1D5DB')
      .textAlign(TextAlign.Center)
      .layoutWeight(1)
      .height(26)
      .backgroundColor(this.intensity === index ? '#FDE68A' : '#20242C')
      .borderRadius(13)
      .onClick(() => {
        this.intensity = index;
        this.statusText = `${label} intensity`;
      })
  }

  @Builder
  MetricTile(label: string, value: string): void {
    Column({ space: 2 }) {
      Text(label)
        .fontSize(8)
        .fontColor('#9CA3AF')
        .maxLines(1)
      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#F8FAFC')
        .maxLines(1)
    }
    .width('48%')
    .padding({ left: 8, right: 8, top: 6, bottom: 6 })
    .backgroundColor('#20242C')
    .clipShape(new RectShape({ width: '100%', height: '100%', radius: 10 }).fill('#FFFFFF'))
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ShapePreview(): void {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(124)
        .height(92)
        .backgroundColor(this.modeAccent())
        .opacity(0.28)
        .clipShape(new EllipseShape({ width: 124, height: 92 }))

      Column()
        .width(126)
        .height(94)
        .backgroundColor('#2A2F39')
        .clipShape(new PathShape({
          commands: 'M14 46 C14 18 40 6 64 14 C91 4 116 22 112 52 C108 82 84 92 60 84 C34 92 10 74 14 46 Z'
        }))

      Column({ space: 2 }) {
        Text(this.modeLabel())
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .maxLines(1)
        Text(this.modePace())
          .fontSize(10)
          .fontColor('#D1D5DB')
          .maxLines(1)
      }
      .width(106)
      .height(76)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#111827')
      .borderRadius(20)
    }
    .width('100%')
    .height(104)
  }

  @Builder
  SettingsPanel(): void {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        this.MetricTile('Distance', this.modeDistance())
        this.MetricTile('Target', `${this.targetMinutes} min`)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row({ space: 6 }) {
        this.IntensityPill('Easy', 0)
        this.IntensityPill('Base', 1)
        this.IntensityPill('Hard', 2)
      }
      .width('100%')

      Row({ space: 6 }) {
        Button('Refresh')
          .height(28)
          .layoutWeight(1)
          .fontSize(10)
          .onClick(() => {
            this.runMenuAction(0);
          })
        Button(this.settingsOpen ? 'Fold' : 'Open')
          .height(28)
          .layoutWeight(1)
          .fontSize(10)
          .onClick(() => {
            this.runMenuAction(1);
          })
      }
      .width('100%')

      if (this.settingsOpen) {
        Button('Inspect ExpandMode')
          .height(28)
          .width('100%')
          .fontSize(10)
          .onClick(() => {
            this.inspectExpandMode();
          })
      }
    }
    .id('settingsPanel')
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor('#171B22')
    .borderRadius(18)
  }

  build() {
    Scroll() {
      Column({ space: 8 }) {
        Text('Workout Widget')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F8FAFC')
          .maxLines(1)

        Column({ space: 8 }) {
          this.ShapePreview()

          Row({ space: 6 }) {
            this.ModePill('Run', 0)
            this.ModePill('Walk', 1)
            this.ModePill('Cycle', 2)
          }
          .width('100%')

          this.SettingsPanel()

          Row({ space: 6 }) {
            Text(this.intensityLabel)
              .fontSize(10)
              .fontColor(this.modeAccent())
              .layoutWeight(1)
              .maxLines(1)
            Text(this.statusText)
              .fontSize(8)
              .fontColor('#A7B0BE')
              .layoutWeight(2)
              .textAlign(TextAlign.End)
              .maxLines(1)
          }
          .width('100%')
        }
        .id('workoutWidgetCard')
        .width('100%')
        .padding({ left: 12, right: 12, top: 10, bottom: 10 })
        .backgroundColor('#0E1116')
        .borderRadius(28)
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 18, bottom: 18 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#05070B')
  }
}