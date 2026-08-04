import {
  AddFormMenuItem,
  ColorMetrics,
  LengthMetrics,
  MultiCapsuleSegmentButtonV2,
  SegmentButton,
  SegmentButtonItemOptionsArray,
  SegmentButtonOptions,
  SegmentButtonV2Items
} from '@kit.ArkUI';
import { Want } from '@kit.AbilityKit';

@Component
export struct AdvancedModuleShowcase {
  @State selectedModeIndexes: number[] = [0];
  @State intensityIndexes: number[] = [1];
  @State intensityOptions: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [
      { text: 'Easy' },
      { text: 'Base' },
      { text: 'Hard' }
    ],
    multiply: false
  });

  private readonly segmentItems: SegmentButtonV2Items = new SegmentButtonV2Items([
    { text: 'Run', accessibilityText: 'Run workout mode' },
    { text: 'Walk', accessibilityText: 'Walk workout mode' },
    { text: 'Cycle', accessibilityText: 'Cycle workout mode' }
  ]);
  private readonly intensityItems: SegmentButtonItemOptionsArray = SegmentButtonItemOptionsArray.create([
    { text: 'Easy' },
    { text: 'Base' },
    { text: 'Hard' }
  ]);
  private readonly formWant: Want = {
    bundleName: 'com.example.howtobuildshapesegmentbutton',
    abilityName: 'EntryAbility',
    parameters: {
      formName: 'WorkoutModeSelector',
      formDimension: 'circle'
    }
  };

  @Builder
  WidgetFormMenu(): void {
    Menu() {
      AddFormMenuItem(this.formWant, 'workoutWidgetCard', {
        style: {
          options: {
            content: 'Add widget'
          }
        }
      })
      MenuItem({ content: `Items: ${this.intensityItems.length}` })
    }
  }

  build() {
    Column({ space: 8 }) {
      MultiCapsuleSegmentButtonV2({
        items: this.segmentItems,
        selectedIndexes: this.selectedModeIndexes,
        $selectedIndexes: (indexes: number[]) => {
          this.selectedModeIndexes = indexes.length > 0 ? [indexes[indexes.length - 1]] : [0];
        },
        itemFontSize: LengthMetrics.vp(10),
        itemSelectedFontSize: LengthMetrics.vp(10),
        itemFontWeight: FontWeight.Medium,
        itemSelectedFontWeight: FontWeight.Bold,
        itemFontColor: ColorMetrics.rgba(199, 206, 218, 1),
        itemSelectedFontColor: ColorMetrics.rgba(7, 17, 30, 1),
        itemBackgroundColor: ColorMetrics.rgba(31, 41, 55, 1),
        itemSelectedBackgroundColor: ColorMetrics.rgba(143, 217, 200, 1),
        itemBorderRadius: LengthMetrics.vp(16),
        itemMinHeight: LengthMetrics.vp(30)
      })

      SegmentButton({
        options: this.intensityOptions,
        selectedIndexes: $intensityIndexes,
        maxFontScale: 1.0
      })
        .height(32)
    }
    .width('100%')
  }
}
