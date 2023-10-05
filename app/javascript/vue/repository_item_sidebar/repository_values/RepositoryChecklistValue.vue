<template>
  <div id="repository-checklist-value-wrapper" class="flex flex-col min-min-h-[46px] h-auto gap-[6px]">
    <div class="font-inter text-sm font-semibold leading-5">
      {{ colName }}
    </div>
    <div>
      <checklist-select
        v-if="permissions?.can_manage_repository_rows"
        @change="changeSelected"
        @update="update"
        :initialSelectedValues="initialSelectedValues"
        :withButtons="true"
        :withEditCursor="true"
        ref="ChecklistSelector"
        :options="options"
        :placeholder="
          i18n.t(
            'repositories.item_card.dropdown_placeholder'
          )
        "
        :no-options-placeholder="
          i18n.t(
            'repositories.item_card.dropdown_placeholder'
          )
        "
      />
      <div v-else-if="colVal.length"
        class="text-sn-dark-grey font-inter text-sm font-normal leading-5 h-fit overflow-auto grid auto-rows-auto grid-cols-3">
        <div v-for="(checklistItem, index) in allChecklistItems" :key="index">
          <div id="checklist-item" class="min-w-max">
            {{ `${checklistItem.label} |` }}
          </div>
        </div>
      </div>
      <div v-else class="text-sn-dark-grey font-inter text-sm font-normal leading-5">
        {{ i18n.t('repositories.item_card.repository_checklist_value.no_checklist') }}
      </div>
    </div>
  </div>
</template>

<script>
import ChecklistSelect from '../../shared/checklist_select.vue'
import repositoryColumnMixin from './mixins/repository_column.js';

export default {
  name: 'RepositoryChecklistValue',
  mixins:[repositoryColumnMixin],
  components: {
    'checklist-select': ChecklistSelect
  },
  data() {
    return {
      options: [],
      initialSelectedValues: [],
      isLoading: false,
    }
  },
  props: {
    data_type: String,
    colId: Number,
    colName: String,
    colVal: Array,
    permissions: null,
    optionsURL: String
  },
  mounted() {
    this.fetchChecklistItems();
  },
  methods: {
    fetchChecklistItems() {
      this.isLoading = true;

      $.get(this.optionsURL, data => {
        if (Array.isArray(data)) {
          this.options = data.map((option) => {
            const {value, label} = option;
            return {id: value, label: label};
          });
          return false;
        }

        this.options = [];
      }).always(() => {
        this.isLoading = false;
        this.initialSelectedValues = this.colVal.map((item) => item.value);
      });
    },
    changeSelected(selectedChecklistItems) {
      this.selectedChecklistItems = selectedChecklistItems;
    },
  },
}
</script>
