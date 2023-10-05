<template>
  <div id="repository-status-value-wrapper" class="flex flex-col min-min-h-[46px] h-auto gap-[6px]">
    <div class="font-inter text-sm font-semibold leading-5">
      {{ colName }}
    </div>
    <div>
      <select-search
        v-if="permissions?.can_manage_repository_rows"
        @change="changeSelected"
        @update="update"
        :value="selected"
        :withClearButton="true"
        :withEditCursor="true"
        ref="DropdownSelector"
        :options="options"
        :isLoading="isLoading"
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
        :searchPlaceholder="
          i18n.t(
            'repositories.item_card.dropdown_placeholder'
          )
        "
      />
      <div v-else-if="status && icon" class="text-sn-dark-grey font-inter text-sm font-normal leading-5 ">
        <i class="text-lg">{{ icon }}</i>
        {{ status }}
      </div>
      <div v-else class="text-sn-dark-grey font-inter text-sm font-normal leading-5">
        {{ i18n.t('repositories.item_card.repository_status_value.no_status') }}
      </div>
    </div>
  </div>
</template>

<script>
import SelectSearch from '../../shared/select_search.vue'
import repositoryColumnMixin from './mixins/repository_column.js';

export default {
  name: 'RepositoryStatusValue',
  components: {
    'select-search': SelectSearch
  },
  mixins:[repositoryColumnMixin],
  data() {
    return {
      id: null,
      icon: null,
      status: null,
      selected: null,
      isLoading: true,
      options: []
    }
  },
  props: {
    data_type: String,
    colId: Number,
    colName: String,
    colVal: Object,
    optionsURL: String,
    permissions: null
  },
  created() {
    this.id = this.colVal.id
    this.icon = this.colVal.icon
    this.status = this.colVal.status
  },
  mounted() {
    this.isLoading = true;

    $.get(this.optionsURL, data => {
      if (Array.isArray(data)) {
        this.options = data.map((option) => {
          const {value, label} = option;
          return [value, label];
        });
        return false;
      }
      this.options = [];
    }).always(() => {
      this.isLoading = false;
      this.selected = this.id;
    });
  },
  methods: {
    changeSelected(id) {
      this.selected = id;
      if (id) {
        this.update(id);
      }
    },
  }
}
</script>
