<template>
  <div id="repository-text-value-wrapper" class="flex flex-col min-min-h-[46px] h-auto gap-[6px]">
    <div class="flex flex-row justify-between items-center">
      <span class="font-inter text-sm font-semibold leading-5">{{ colName }}</span>
      <span class="text-sn-blue hover:cursor-pointer" @click="toggleCollapse">
        {{ collapsed ?
            i18n.t('repositories.item_card.expand') :
            i18n.t('repositories.item_card.collapse') }}
      </span>
    </div>
    <div>
      <inline-edit
        v-if="permissions?.can_manage_repository_rows"
        :value="colVal.edit"
        :allowBlank="true"
        :smartAnnotation="false"
        :attributeName="`repository-text-value ${colId}`"
        :allowNewLine="false"
        :singleLine="false"
        :expandable="expandable"
        :collapsed="collapsed"
        @editingEnabled="editing = true"
        @editingDisabled="editing = false"
        @update="update"
      ></inline-edit>
      <div v-else-if="colVal.edit" class="text-sn-dark-grey font-inter text-sm font-normal leading-5">
        {{ colVal.edit }}
      </div>
      <div v-else class="text-sn-dark-grey font-inter text-sm font-normal leading-5">
        {{ i18n.t('repositories.item_card.repository_text_value.no_text') }}
      </div>
    </div>
  </div>
</template>

<script>
import InlineEdit from '../../shared/inline_edit.vue';
import repositoryColumnMixin from './mixins/repository_column.js';

export default {
  name: 'RepositoryTextValue',
  mixins: [repositoryColumnMixin],
  components: {
    'inline-edit': InlineEdit
  },
  data() {
    return {
      edit: null,
      view: null,
      expandable: true,
      collapsed: true
    }
  },
  props: {
    data_type: String,
    colId: Number,
    colName: String,
    colVal: Object,
    permissions: null
  },
  created() {
    this.edit = this.colVal.edit
    this.view = this.colVal.view
  },
  methods: {
    toggleCollapse() {
      if (this.expandable) {
        this.collapsed = !this.collapsed;
      }
    }
  }
}
</script>
